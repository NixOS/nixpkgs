{ lib, ... }:
{
  name = "gnome-keyring";
  meta.teams = [ lib.teams.gnome ];

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [ ./common/user-account.nix ];

      services.gnome.gnome-keyring.enable = true;
      environment.systemPackages = [ pkgs.libsecret ];

      specialisation.changed-unit.configuration = {
        systemd.user.services.gnome-keyring-daemon.environment.NIXOS_TEST_CHANGE = "1";
      };
    };

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
    in
    ''
      import shlex

      uid = ${toString user.uid}

      def as_user(name, command):
          user_id = machine.succeed(f"id -u {name}").strip()
          env = f"export XDG_RUNTIME_DIR=/run/user/{user_id} DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/{user_id}/bus;"
          return machine.succeed(f"su - {name} -c {shlex.quote(f'{env} {command}')}")

      def as_alice(command):
          return as_user("${user.name}", command)

      def login(tty):
          machine.wait_until_tty_matches(tty, "login: ")
          machine.send_chars("${user.name}\n")
          machine.wait_until_tty_matches(tty, "Password: ")
          machine.send_chars("${user.password}\n")
          machine.wait_until_succeeds(f"pgrep -u ${user.name} -t tty{tty} bash")

      def daemons(name="${user.name}"):
          return machine.succeed(f"ps -u {name} -o args= | grep '[g]nome-keyring-daemon' || true").splitlines()

      def unit_property(prop, unit):
          return machine.succeed(
              f"systemctl --user -M ${user.name}@ show --property={prop} --value {unit}"
          ).strip()

      def assert_unlocked():
          locked = as_alice(
              "busctl --user get-property org.freedesktop.secrets"
              " /org/freedesktop/secrets/collection/login"
              " org.freedesktop.Secret.Collection Locked"
          )
          assert locked.strip() == "b false", f"login keyring is locked: {locked!r}"

      def assert_secret_readable():
          assert as_alice("timeout 30 secret-tool lookup service nixos-test") == "hunter2"

      machine.wait_for_unit("multi-user.target")

      with subtest("PAM unlocks the socket-activated daemon at login"):
          login("1")
          machine.wait_for_unit("gnome-keyring-daemon.service", "${user.name}")
          assert len(daemons()) == 1, f"expected one daemon: {daemons()}"
          assert_unlocked()
          as_alice("printf hunter2 | timeout 30 secret-tool store --label=test service nixos-test")
          assert_secret_readable()

      with subtest("A session --start initializes the running daemon"):
          # GNOME's autostart entries run this once the session is up.
          output = as_alice("gnome-keyring-daemon --start --components=secrets")
          assert f"GNOME_KEYRING_CONTROL=/run/user/{uid}/keyring" in output, output
          assert len(daemons()) == 1, f"expected one daemon: {daemons()}"
          assert_unlocked()

      with subtest("A switch that changes the unit keeps the unlocked daemon"):
          pid = unit_property("MainPID", "gnome-keyring-daemon.service")
          output = machine.succeed(
              "/run/current-system/specialisation/changed-unit/bin/switch-to-configuration test 2>&1"
          )
          assert any(
              line.startswith("NOT restarting") and "gnome-keyring-daemon.service" in line
              for line in output.splitlines()
          ), output
          new_pid = unit_property("MainPID", "gnome-keyring-daemon.service")
          assert new_pid == pid, f"the switch replaced daemon {pid} with {new_pid}"
          assert_unlocked()
          assert_secret_readable()

      with subtest("The daemon stops with the user manager at logout"):
          machine.send_chars("exit\n")
          machine.wait_until_succeeds(
              f"[ $(systemctl show --property=ActiveState --value user@{uid}.service) = inactive ]"
          )
          machine.wait_until_fails("ps -u ${user.name} -o args= | grep '[g]nome-keyring-daemon'")

      with subtest("PAM unlocks the existing login keyring at the next login"):
          login("1")
          machine.wait_for_unit("gnome-keyring-daemon.service", "${user.name}")
          assert len(daemons()) == 1, f"expected one daemon: {daemons()}"
          assert_unlocked()
          assert_secret_readable()

      with subtest("The socket does not take over a path owned by a PAM-started daemon"):
          machine.succeed(
              "systemctl --user -M ${user.name}@ stop gnome-keyring-daemon.socket gnome-keyring-daemon.service"
          )
          machine.wait_until_fails("ps -u ${user.name} -o args= | grep '[g]nome-keyring-daemon'")
          machine.fail(f"test -e /run/user/{uid}/keyring/control")
          # No control socket exists, so pam_gnome_keyring starts a --login daemon.
          machine.send_key("alt-f2")
          login("2")
          pam_daemon = machine.succeed("pgrep -u ${user.name} -f -- '--daemonize --login'").strip()
          machine.succeed("systemctl --user -M ${user.name}@ start gnome-keyring-daemon.socket")
          state = unit_property("ActiveState", "gnome-keyring-daemon.socket")
          assert state == "inactive", f"the socket started over the PAM-started daemon: {state}"
          machine.execute("systemctl --user -M ${user.name}@ start gnome-keyring-daemon.service")
          state = unit_property("ActiveState", "gnome-keyring-daemon.service")
          assert state == "inactive", f"the service started over the PAM-started daemon: {state}"
          # The first Secret Service call D-Bus-activates a --start that initializes it.
          assert_unlocked()
          owner = as_alice("busctl --user status org.freedesktop.secrets | grep '^PID='").strip()
          assert owner == f"PID={pam_daemon}", f"{owner} is not the PAM-started daemon {pam_daemon}"

      with subtest("D-Bus activation without a PAM unlock goes through the socket"):
          # Lingering starts the user manager without a login, so pam_gnome_keyring never runs.
          machine.succeed("loginctl enable-linger bob")
          machine.wait_for_unit(f"user@{machine.succeed('id -u bob').strip()}.service")
          as_user("bob", "busctl --user call org.freedesktop.secrets /org/freedesktop/secrets"
                  " org.freedesktop.Secret.Service ReadAlias s default")
          machine.wait_for_unit("gnome-keyring-daemon.service", "bob")
          main_pid = machine.succeed(
              "systemctl --user -M bob@ show --property=MainPID --value gnome-keyring-daemon.service"
          ).strip()
          owner = as_user("bob", "busctl --user status org.freedesktop.secrets | grep '^PID='").strip()
          assert owner == f"PID={main_pid}", f"{owner} does not match the unit's MainPID {main_pid}"
          # Only D-Bus activation leaves this helper, so the socket was reached through it.
          machine.succeed("ps -u bob -o args= | grep '[g]nome-keyring-daemon --start --foreground'")
          others = [d for d in daemons("bob") if "--start" not in d]
          assert len(others) == 1, f"expected one daemon outside the --start helper: {others}"
    '';
}
