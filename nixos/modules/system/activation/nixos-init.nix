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

  config = lib.mkMerge [
    {
      boot.bootspec.extensions = {
        "org.nixos.nixos-init.v1" = {
          firmware = "${config.hardware.firmware}/lib/firmware";
          modprobe_binary = "${pkgs.kmod}/bin/modprobe";
          nix_store_mount_opts = config.boot.nixStoreMountOpts;
        }
        // lib.optionalAttrs (config.environment.binsh != null) {
          sh_binary = config.environment.binsh;
        }
        // lib.optionalAttrs (config.environment.usrbinenv != null) {
          env_binary = config.environment.usrbinenv;
        }
        // lib.optionalAttrs config.system.etc.overlay.enable {
          etc_metadata_image = config.system.build.etcMetadataImage;
          etc_basedir = config.system.build.etcBasedir;
        };
      };
    }
    (lib.mkIf cfg.enable {
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
        {
          assertion = config.boot.postBootCommands == "";
          message = "nixos-init cannot be used with boot.postBootCommands";
        }
        {
          assertion = config.powerManagement.powerUpCommands == "";
          message = "nixos-init cannot be used with powerManagement.powerUpCommands";
        }
      ];
    })
  ];
}
