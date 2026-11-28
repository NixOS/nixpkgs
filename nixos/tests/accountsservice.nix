{ pkgs, ... }:

let
  alice = {
    isNormalUser = true;
    description = "Alice";
  };
  icon = "${pkgs.nixos-icons}/share/icons/hicolor/48x48/apps/nix-snowflake.png";
in
{
  name = "accountsservice";

  nodes = {
    machine = {
      environment.systemPackages = [ pkgs.jq ];
      services.accounts-daemon.enable = true;
      security.polkit.enable = true;
      users.users.alice = alice;
    };

    immutable = {
      environment.systemPackages = [ pkgs.jq ];
      services.accounts-daemon.enable = true;
      security.polkit.enable = true;
      users.mutableUsers = false;
      users.allowNoPasswordLogin = true;
      users.users.alice = alice;
    };
  };

  testScript = ''
    accounts = "busctl call org.freedesktop.Accounts /org/freedesktop/Accounts org.freedesktop.Accounts"
    not_supported = "not supported without users.mutableUsers"

    def find_user(machine, name):
        return machine.succeed(f"busctl call -j org.freedesktop.Accounts /org/freedesktop/Accounts org.freedesktop.Accounts FindUserByName s {name} | jq -j '.data[]'")

    def get_property(machine, user, name):
        return machine.succeed(f"busctl get-property -j org.freedesktop.Accounts {user} org.freedesktop.Accounts.User {name} | jq -j .data")

    def call_user(user, method, signature, *args):
        return f"busctl call -- org.freedesktop.Accounts {user} org.freedesktop.Accounts.User {method} {signature} {' '.join(args)}"

    def as_alice(command):
        return f"su - alice -c '{command}'"

    def run_in_daemon_namespace(machine, command):
        return machine.execute(f"nsenter -t $(systemctl show -p MainPID --value accounts-daemon) -m {command}")

    start_all()

    for m in [machine, immutable]:
        m.start_job("accounts-daemon.service")
        m.wait_for_unit("accounts-daemon.service")
        t.assertEqual(get_property(m, find_user(m, "alice"), "RealName"), "Alice")

    with subtest("Mutable users can still be created, renamed and deleted"):
        machine.succeed(f"{accounts} CreateUser ssi bob Bob 0")
        machine.succeed("getent passwd bob")
        bob = find_user(machine, "bob")
        machine.succeed(call_user(bob, "SetRealName", "s", "Robert"))
        machine.wait_until_succeeds("getent passwd bob | grep -q Robert")
        machine.succeed(f"{accounts} DeleteUser xb $(id -u bob) true")
        machine.fail("getent passwd bob")

    user = find_user(immutable, "alice")
    shadow = immutable.succeed("sha256sum /etc/passwd /etc/shadow /etc/group")

    with subtest("Immutable users can change their own icon, email and language"):
        immutable.succeed("install -o alice -m 600 ${icon} /home/alice/face.png")
        immutable.succeed(as_alice(call_user(user, "SetIconFile", "s", "/home/alice/face.png")))
        immutable.succeed("cmp ${icon} /var/lib/AccountsService/icons/alice")
        immutable.succeed("install -o alice -m 600 ${icon} /tmp/face.png")
        immutable.succeed(as_alice(call_user(user, "SetIconFile", "s", "/tmp/face.png")))
        immutable.succeed(as_alice(call_user(user, "SetEmail", "s", "alice@example.org")))
        immutable.succeed(as_alice(call_user(user, "SetLanguage", "s", "en_US.UTF-8")))
        immutable.succeed("grep -q alice@example.org /var/lib/AccountsService/users/alice")
        t.assertEqual(get_property(immutable, user, "Email"), "alice@example.org")

    with subtest("Immutable users cannot be changed"):
        for method, signature, args in [
            ("SetRealName", "s", ["Eve"]),
            ("SetAccountType", "i", ["1"]),
            ("SetAutomaticLogin", "b", ["true"]),
            ("SetPasswordExpirationPolicy", "xxxx", ["0", "99999", "7", "-1"]),
            ("SetUserExpirationPolicy", "x", ["-1"]),
        ]:
            t.assertIn(not_supported, immutable.fail(f"{call_user(user, method, signature, *args)} 2>&1"))
        own_expiration_policy = call_user(user, "SetPasswordExpirationPolicy", "xxxx", "0", "99999", "7", "-1")
        t.assertIn(not_supported, immutable.fail(f"{as_alice(own_expiration_policy)} 2>&1"))
        t.assertIn(not_supported, immutable.fail(f"{accounts} CreateUser ssi bob Bob 0 2>&1"))
        t.assertEqual(immutable.succeed("sha256sum /etc/passwd /etc/shadow /etc/group"), shadow)

    with subtest("The daemon cannot write to /etc or home directories with immutable users"):
        for path in ["/etc/probe", "/root/probe", "/home/alice/probe"]:
            status, output = run_in_daemon_namespace(immutable, f"touch {path}")
            t.assertNotEqual(status, 0, f"daemon namespace could write {path}")
        status, _ = run_in_daemon_namespace(machine, "touch /etc/probe")
        t.assertEqual(status, 0, "mutable users must keep write access to /etc")

    with subtest("No assertion failures in the daemon"):
        for m in [machine, immutable]:
            m.fail("journalctl -b -u accounts-daemon --no-pager | grep -iE 'critical|assertion'")
  '';
}
