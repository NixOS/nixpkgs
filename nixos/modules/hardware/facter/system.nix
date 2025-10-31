{
  config,
  options,
  lib,
  ...
}:
{
  # Skip setting hostPlatform in test VMs where it's read-only
  # Tests have virtualisation.test options and import read-only.nix
  config.nixpkgs = lib.optionalAttrs (!(options ? virtualisation.test)) {
    hostPlatform = lib.mkIf (
      config.hardware.facter.report.system or null != null && !options.nixpkgs.pkgs.isDefined
    ) (lib.mkDefault config.hardware.facter.report.system);
  };
}
