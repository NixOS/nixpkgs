import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "intune";
    meta = {
      maintainers = with pkgs.lib.maintainers; [ rhysmdnz ];
    };
    enableOCR = true;

    nodes.machine =
      { nodes, ... }:
      let
        user = nodes.machine.users.users.alice;
      in
      {
        services.intune.enable = true;
        services.gnome.gnome-keyring.enable = true;
        imports = [
          ./common/user-account.nix
          ./common/x11.nix
        ];
        test-support.displayManager.auto.user = user.name;
        environment = {
          variables.DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/${builtins.toString user.uid}/bus";
        };
      };
    nodes.pam =
      { nodes, ... }:
      let
        user = nodes.machine.users.users.alice;
      in
      {
        services.intune.enable = true;
        imports = [ ./common/user-account.nix ];
      };

    testScript = ''
      start_all()

      # Check System Daemons successfully start
      machine.succeed("systemctl start microsoft-identity-device-broker.service")
      machine.succeed("systemctl start intune-daemon.service")

      # Check User Daemons and intune-portal execurtable works
      # Going any further than starting it would require internet access and a microsoft account
      machine.wait_for_x()
      # TODO: This needs an unlocked user keychain before it will work
      #machine.succeed("su - alice -c 'systemctl start --user microsoft-identity-broker.service'")
      machine.succeed("su - alice -c 'systemctl start --user intune-agent.service'")
      machine.succeed("su - alice -c intune-portal >&2 &")
      machine.wait_for_text("Intune Agent")

      # Check logging in creates password file
      def login_as_alice():
          pam.wait_until_tty_matches("1", "login: ")
          pam.send_chars("alice\n")
          pam.wait_until_tty_matches("1", "Password: ")
          pam.send_chars("foobar\n")
          pam.wait_until_tty_matches("1", "alice\@pam")

      pam.wait_for_unit("multi-user.target")
      login_as_alice()
      pam.wait_for_file("/run/intune/1000/pwquality")
    '';
  }
)
