{ lib, pkgs, ... }:
{
  name = "syncthing-guiPasswordFile";
  meta.maintainers = with lib.maintainers; [ nullcube ];
  enableOCR = true;

  nodes.machine = {
    imports = [ ../common/x11.nix ];
    environment.systemPackages = with pkgs; [
      syncthing
      xdotool
    ];

    programs.firefox = {
      enable = true;
      preferences = {
        # Prevent firefox from asking to save the password
        "signon.rememberSignons" = false;
      };
    };

    services.syncthing = {
      enable = true;
      settings.options.urAccepted = -1;
      settings.gui = {
        insecureAdminAccess = false;
        user = "alice";
      };
      guiPasswordFile = (pkgs.writeText "syncthing-password-file" ''alice_password'').outPath;
    };
  };

  testScript = ''
    machine.wait_for_unit("syncthing.service")
    machine.wait_for_x()
    machine.execute("xterm -e 'firefox 127.0.0.1:8384' >&2 &")
    machine.wait_for_window("Syncthing")
    machine.screenshot("pre-login")

    with subtest("Syncthing requests authentication"):
      machine.wait_for_text("Authentication Required", 10)

    with subtest("Syncthing password is valid"):
      machine.execute("xdotool type \"alice\"")
      machine.execute("xdotool key Tab")
      machine.execute("xdotool type \"alice_password\"")
      machine.execute("xdotool key Enter")
      machine.sleep(2)
      machine.wait_for_text("This Device", 10)
      machine.screenshot("post-login")

    with subtest("Plaintext Syncthing password is not in final config"):
      config = machine.succeed("cat /var/lib/syncthing/.config/syncthing/config.xml")
      assert "alice_password" not in config
  '';
}
