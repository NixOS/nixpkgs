{ pkgs, lib, ... }:

{
  name = "gnupg";
  meta = with lib.maintainers; {
    maintainers = [ rnhmjoj ];
  };

  # server for testing SSH
  nodes.server =
    { ... }:
    {
      imports = [ ../modules/profiles/minimal.nix ];

      users.users.alice.isNormalUser = true;
      services.openssh.enable = true;
    };

  # machine for testing GnuPG
  nodes.machine =
    { pkgs, ... }:
    {
      imports = [ ../modules/profiles/minimal.nix ];

      users.users.alice.isNormalUser = true;
      services.getty.autologinUser = "alice";

      environment.shellInit = ''
        # preset a key passphrase in gpg-agent
        preset_key() {
          # find all keys
          case "$1" in
            ssh) grips=$(awk '/^[0-9A-F]/{print $1}' "''${GNUPGHOME:-$HOME/.gnupg}/sshcontrol") ;;
            pgp) grips=$(gpg --with-keygrip --list-secret-keys | awk '/Keygrip/{print $3}') ;;
          esac

          # try to preset the passphrase for each key found
          for grip in $grips; do
            "$(gpgconf --list-dirs libexecdir)/gpg-preset-passphrase" -c -P "$2" "$grip"
          done
        }
      '';

      programs.gnupg.agent.enable = true;
      programs.gnupg.agent.enableSSHSupport = true;
    };

  testScript = ''
    import shlex


    def as_alice(command: str) -> str:
        """
        Wraps a command to run it as Alice in a login shell
        """
        quoted = shlex.quote(command)
        return "su --login alice --command " + quoted


    start_all()

    with subtest("Wait for the autologin"):
        machine.wait_until_tty_matches("1", "alice@machine")

    with subtest("Can generate a PGP key"):
        # Note: this needs a tty because of pinentry
        machine.send_chars("gpg --gen-key\n")
        machine.wait_until_tty_matches("1", "Real name:")
        machine.send_chars("Alice\n")
        machine.wait_until_tty_matches("1", "Email address:")
        machine.send_chars("alice@machine\n")
        machine.wait_until_tty_matches("1", "Change")
        machine.send_chars("O\n")
        machine.wait_until_tty_matches("1", "Please enter")
        machine.send_chars("pgp_p4ssphrase")
        machine.send_key("tab")
        machine.send_chars("pgp_p4ssphrase")
        machine.wait_until_tty_matches("1", "Passphrases match")
        machine.send_chars("\n")
        machine.wait_until_tty_matches("1", "public and secret key created")

    with subtest("Confirm the key is in the keyring"):
        machine.wait_until_succeeds(as_alice("gpg --list-secret-keys | grep -q alice@machine"))

    with subtest("Can generate and add an SSH key"):
        machine.succeed(as_alice("ssh-keygen -t ed25519 -f alice -N ssh_p4ssphrase"))

        # Note: apparently this must be run before using the OpenSSH agent
        # socket for the first time in a tty. It's not needed for `ssh`
        # because there's a hook that calls it automatically (only in NixOS).
        machine.send_chars("gpg-connect-agent updatestartuptty /bye\n")

        # Note: again, this needs a tty because of pinentry
        machine.send_chars("ssh-add alice\n")
        machine.wait_until_tty_matches("1", "Enter passphrase")
        machine.send_chars("ssh_p4ssphrase\n")
        machine.wait_until_tty_matches("1", "Please enter")
        machine.send_chars("ssh_agent_p4ssphrase")
        machine.send_key("tab")
        machine.send_chars("ssh_agent_p4ssphrase")
        machine.wait_until_tty_matches("1", "Passphrases match")
        machine.send_chars("\n")

    with subtest("Confirm the SSH key has been registered"):
        machine.wait_until_succeeds(as_alice("ssh-add -l | grep -q alice@machine"))

    with subtest("Can preset the key passphrases in the agent"):
        machine.succeed(as_alice("echo allow-preset-passphrase > .gnupg/gpg-agent.conf"))
        machine.succeed(as_alice("pkill gpg-agent"))
        machine.succeed(as_alice("preset_key pgp pgp_p4ssphrase"))
        machine.succeed(as_alice("preset_key ssh ssh_agent_p4ssphrase"))

    with subtest("Can encrypt and decrypt a message"):
        machine.succeed(as_alice("echo Hello | gpg -e -r alice | gpg -d | grep -q Hello"))

    with subtest("Can log into the server"):
        # Install Alice's public key
        public_key = machine.succeed(as_alice("cat alice.pub"))
        server.succeed("mkdir /etc/ssh/authorized_keys.d")
        server.succeed(f"printf '{public_key}' > /etc/ssh/authorized_keys.d/alice")

        server.wait_for_open_port(22)
        machine.succeed(as_alice("ssh -i alice -o StrictHostKeyChecking=no server exit"))
  '';
}
