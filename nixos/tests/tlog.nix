{ pkgs, lib, ... }:

let
  inherit (import ./ssh-keys.nix pkgs) snakeOilPrivateKey snakeOilPublicKey;
in
{
  name = "tlog";
  meta.maintainers = with lib.maintainers; [ oakenshield ];

  nodes.machine =
    { config, ... }:
    {
      programs.tlog = {
        enable = true;
        # Flush quickly so the test does not wait out the default 10s latency.
        settings.rec-session.latency = 1;
      };

      services.openssh.enable = true;

      users.users.alice = {
        isNormalUser = true;
        password = "foobar";
        shell = "${config.security.wrapperDir}/tlog-rec-session";
        openssh.authorizedKeys.keys = [ snakeOilPublicKey ];
      };
    };

  testScript = ''
    import json

    def recorded(marker):
        machine.wait_until_succeeds(
            f"journalctl TLOG_USER=alice -o cat | grep -F '{marker}'", timeout=60
        )

    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("sshd.service")
    machine.succeed(
        "install -Dm600 ${snakeOilPrivateKey} /root/.ssh/id_rsa",
        "ssh-keyscan localhost > /root/.ssh/known_hosts",
    )

    with subtest("wrapper, lock dir and config are in place"):
        machine.succeed("test -u /run/wrappers/bin/tlog-rec-session")
        machine.succeed("test -g /run/wrappers/bin/tlog-rec-session")
        machine.succeed("[ \"$(stat -c %U:%G /run/tlog)\" = tlog:tlog ]")
        machine.succeed("grep -F /run/wrappers/bin/tlog-rec-session /etc/shells")
        conf = json.loads(machine.succeed("cat /etc/tlog/tlog-rec-session.conf"))
        assert conf["latency"] == 1, conf
        assert conf["shell"] == "/run/current-system/sw/bin/bash", conf

    with subtest("recorded user cannot pre-create session locks"):
        # Positive control: su itself works, so the failure below is the lock dir.
        machine.succeed("su alice -s /bin/sh -c true")
        machine.fail("su alice -s /bin/sh -c 'touch /run/tlog/session.1.lock'")

    # Each marker is printed via shell arithmetic, so it only appears in the
    # recording if terminal *output* was captured, not just the typed input.

    with subtest("su - into a recorded user is recorded"):
        rc, out = machine.execute("su - alice -c 'echo tlog-su-$((6*7))' 2>&1")
        print(out)
        assert rc == 0 and "tlog-su-42" in out, f"rc={rc}: {out}"
        recorded("tlog-su-42")

    with subtest("console login is recorded"):
        machine.wait_until_tty_matches("1", "login: ")
        machine.send_chars("alice\n")
        machine.wait_until_tty_matches("1", "Password: ")
        machine.send_chars("foobar\n")
        machine.wait_until_tty_matches("1", "Your session is being recorded")
        machine.send_chars("echo tlog-tty-$((6*7)); cat /proc/self/sessionid > /tmp/sid\n")
        machine.wait_for_file("/tmp/sid")

        # 4294967295 means unset; all such sessions would share one lock file.
        sid = machine.succeed("cat /tmp/sid").strip()
        assert sid.isdigit() and sid != "4294967295", f"bad audit session id: {sid!r}"
        # tlog records even when it cannot create the lock, so check that the
        # setuid wrapper really took it, as user tlog.
        machine.succeed(f"[ \"$(stat -c %U /run/tlog/session.{sid}.lock)\" = tlog ]")

        machine.send_chars("exit\n")
        recorded("tlog-tty-42")

    with subtest("ssh session with a pty is recorded"):
        # ssh must not read stdin: in the test driver that is the command channel.
        machine.succeed("ssh -tt alice@localhost 'echo tlog-pty-$((6*7))' < /dev/null")
        recorded("tlog-pty-42")

    with subtest("ssh command without a pty is recorded"):
        machine.succeed("ssh -T alice@localhost 'echo tlog-nopty-$((6*7))' < /dev/null")
        recorded("tlog-nopty-42")

    with subtest("tlog-play replays a recording from the journal"):
        rec = json.loads(
            machine.succeed("journalctl TLOG_USER=alice -o json --grep tlog-pty -n 1")
        )["TLOG_REC"]
        # tlog-play spins on stdin EOF, so give it a pipe that stays open.
        out = machine.succeed(
            f"bash -c 'timeout 60 tlog-play -r journal -M TLOG_REC={rec} < <(sleep 60)'"
        )
        assert "tlog-pty-42" in out, out
  '';
}
