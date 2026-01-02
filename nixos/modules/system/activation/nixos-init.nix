{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.system.nixos-init;
in
{
  options.system.nixos-init = {
    enable = lib.mkEnableOption ''
      nixos-init, a system for bashless initialization.

      This doesn't use any `activationScripts`. Anything set in these options is
      a no-op here.
    '';

    package = lib.mkPackageOption pkgs "nixos-init" { };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.boot.initrd.systemd.enable;
        message = "nixos-init can only be used with boot.initrd.systemd.enable";
      }
      {
        assertion = config.system.etc.overlay.enable;
        message = "nixos-init can only be used with system.etc.overlay.enable";
      }
      {
        assertion = config.services.userborn.enable || config.systemd.sysusers.enable;
        message = "nixos-init can only be used with services.userborn.enable or systemd.sysusers.enable";
      }
    ];
  };
}
