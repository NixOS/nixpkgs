{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    getExe'
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.services.tee-supplicant;

  taDir = "optee_armtz";

  trustedApplications = pkgs.linkFarm "runtime-trusted-applications" (
    map (
      ta:
      let
        # This is safe since we are using it as the path value, so the context
        # will still ensure that this nix store path exists on the running
        # system.
        taFile = builtins.baseNameOf (builtins.unsafeDiscardStringContext ta);
      in
      {
        name = "lib/${taDir}/${taFile}";
        path = ta;
      }
    ) cfg.trustedApplications
  );
in
{
  options.services.tee-supplicant = {
    enable = mkEnableOption "OP-TEE userspace supplicant";

    package = mkPackageOption pkgs "optee-client" { };

    trustedApplications = mkOption {
      type = types.listOf types.path;
      default = [ ];
      description = ''
        A list of full paths to trusted applications that will be loaded at
        runtime by tee-supplicant.
      '';
    };

    pluginPath = mkOption {
      type = types.path;
      default = "/run/current-system/sw/lib/tee-supplicant/plugins";
      description = ''
        The directory where plugins will be loaded from on startup.
      '';
    };

    reeFsParentPath = mkOption {
      type = types.path;
      default = "/var/lib/tee";
      description = ''
        The directory where the secure filesystem will be stored in the rich
        execution environment (REE FS).
      '';
    };
  };

  config = mkIf cfg.enable {
    environment = mkIf (cfg.trustedApplications != [ ]) {
      systemPackages = [ trustedApplications ];
      pathsToLink = [ "/lib/${taDir}" ];
    };

    systemd.services.tee-supplicant = {
      description = "Userspace supplicant for OPTEE-OS";

      serviceConfig = {
        ExecStart = toString [
          (getExe' cfg.package "tee-supplicant")
          "--ta-dir ${taDir}"
          "--fs-parent-path ${cfg.reeFsParentPath}"
          "--plugin-path ${cfg.pluginPath}"
        ];
        Restart = "always";
      };

      after = [ "modprobe@optee.service" ];
      wants = [ "modprobe@optee.service" ];

      wantedBy = [ "multi-user.target" ];
    };
  };
}
