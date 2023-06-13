{ config, pkgs, lib, ... }:
let
  cfg = config.services.tee-supplicant;

  taDir = "optee_armtz";

  trustedApplications = pkgs.linkFarm "runtime-trusted-applications" (map
    (ta:
      let
        # This is safe since we are using it as the path value, so the context
        # will still ensure that this nix store path exists on the running
        # system.
        taFile = builtins.baseNameOf (builtins.unsafeDiscardStringContext ta);
      in
      {
        name = "lib/${taDir}/${taFile}";
        path = ta;
      })
    cfg.trustedApplications);
in
{
  options.services.tee-supplicant = {
    enable = lib.mkEnableOption (lib.mdDoc "OP-TEE userspace supplicant");

    package = lib.mkPackageOptionMD pkgs "optee-client" { };

    trustedApplications = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = lib.mdDoc ''
        A list of full paths to trusted applications that will be loaded at
        runtime by tee-supplicant.
      '';
    };

    pluginPath = lib.mkOption {
      type = lib.types.path;
      default = "/run/current-system/sw/lib/tee-supplicant/plugins";
      description = lib.mdDoc ''
        The directory where plugins will be loaded from on startup.
      '';
    };

    reeFsParentPath = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/tee";
      description = lib.mdDoc ''
        The directory where the secure filesystem will be stored in the rich
        execution environment (REE FS).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment = lib.mkIf (cfg.trustedApplications != [ ]) {
      systemPackages = [ trustedApplications ];
      pathsToLink = [ "/lib/${taDir}" ];
    };

    systemd.services.tee-supplicant = {
      description = "Userspace supplicant for OPTEE-OS";
      serviceConfig = {
        ExecStart = "${lib.getBin cfg.package}/bin/tee-supplicant --ta-dir ${taDir} --fs-parent-path ${cfg.reeFsParentPath} --plugin-path ${cfg.pluginPath}";
        Restart = "always";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
