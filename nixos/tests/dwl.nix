{ lib, ... }:
{
  name = "dwl_test_vm";

  meta = {
    maintainers = with lib.maintainers; [ gurjaka ];
  };

  nodes.machine =
    {
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        ./common/user-account.nix
        ./common/wayland-cage.nix
      ];

      environment.systemPackages = [ pkgs.foot ];

      services.displayManager.defaultSession = lib.mkForce "dwl";

      programs.dwl.enable = true;
    };

  testScript = ''
    with subtest("ensure dwl starts"):
      machine.wait_for_file("/run/user/1000/wayland-0")

    with subtest("ensure foot is installed"):
      machine.succeed("which foot")

    with subtest("ensure we can open a new terminal"):
      # sleep 3 is required to make sure dwl has started
      # TODO: find better way to identify dwl session
      machine.sleep(3)
      machine.send_key("alt-shift-ret")
      machine.sleep(3)
      machine.screenshot("terminal")
  '';
}
