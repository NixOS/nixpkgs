{
  lib,
  pkgs,
  ...
}:
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
      machine.wait_until_succeeds("pgrep -f dwl")

    with subtest("ensure we can open a new terminal"):
      machine.sleep(2)
      machine.screenshot("terminal")
  '';
}
