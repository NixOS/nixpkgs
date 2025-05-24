{ lib, pkgs, ... }:
{
  name = "catnap";
  meta.maintainers = with lib.maintainers; [ phanirithvij ];
  nodes.machine = {
    virtualisation.memorySize = 512;
    environment.systemPackages = with pkgs; [ catnap ];
  };
  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.succeed("catnap")
    machine.succeed("${pkgs.catnap.testsout}/scripts/test-commandline-args.sh")
  '';
}
