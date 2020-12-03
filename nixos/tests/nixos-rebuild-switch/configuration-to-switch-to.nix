{
  lib,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    "${modulesPath}/testing/test-instrumentation.nix"
  ];

  system.rebuild.enableNg = false;

  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
    forceInstall = true;
  };

  documentation.enable = false;

  environment.systemPackages = [
    # make a different config, so that the nixos-rebuild has something to do
    (pkgs.writeShellScriptBin "iAmGeneration" ''
      echo -n ${lib.strings.escapeShellArg (lib.trivial.readFile ./generation.txt)}
    '')
    # for list-generations parsing
    pkgs.jq
  ];
}
