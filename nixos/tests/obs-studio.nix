import ./make-test-python.nix ({ ... }:

{
  name = "obs-studio";

  nodes.machine = { pkgs, ... }: {
    imports = [ ./common/x11.nix ./common/user-account.nix ];

    programs.obs-studio = {
      enable = true;
      plugins = [
        pkgs.obs-studio-plugins.wlrobs
      ];
    };
  };

  testScript = ''
    machine.wait_for_x()
    machine.succeed("obs >&2 &")
    machine.wait_for_window("OBS")
    machine.sleep(1)
    machine.screenshot("obs")
  '';
})
