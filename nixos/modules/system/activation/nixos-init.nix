{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.system.nixos-init;

  specialFileSystems =
    (lib.toposort utils.fsBefore (lib.attrValues config.boot.specialFileSystems)).result;

  nixosInitConfig = {
    nix_store_mount_opts = config.boot.nixStoreMountOpts;
    special_filesystems = map (fs: {
      mountpoint = fs.mountPoint;
      inherit (fs) device options;
      fstype = fs.fsType;
    }) specialFileSystems;
  }
  // lib.optionalAttrs config.boot.kernel.enable {
    firmware = "${config.hardware.firmware}/lib/firmware";
  }
  // lib.optionalAttrs config.boot.modprobeConfig.enable {
    modprobe_binary = "${pkgs.kmod}/bin/modprobe";
  }
  // lib.optionalAttrs config.environment.createBinSh {
    sh_binary = toString config.environment.binsh;
  }
  // lib.optionalAttrs config.environment.createUsrBinEnv {
    env_binary = toString config.environment.usrbinenv;
  }
  // lib.optionalAttrs config.system.etc.overlay.enable {
    etc_metadata_image = config.system.build.etcMetadataImage;
    etc_basedir = config.system.build.etcBasedir;
  };

  # boot.json is not written for containers, so provide the same config
  # in a standalone file in that case.
  needsFallbackConfig = config.boot.isContainer;

  nixosInitConfigFile = pkgs.writeText "nixos-init.json" (builtins.toJSON nixosInitConfig);
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
      boot.bootspec.extensions."org.nixos.nixos-init.v1" = nixosInitConfig;

      system.systemBuilderCommands = lib.optionalString needsFallbackConfig ''
        ln -s ${nixosInitConfigFile} $out/nixos-init.json
      '';
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
      ];
    })
  ];
}
