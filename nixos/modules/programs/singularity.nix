{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.programs.singularity;
in
{

  options.programs.singularity = {
    enable = mkEnableOption (mdDoc "singularity") // {
      description = mdDoc ''
        Whether to install Singularity/Apptainer with system-level overriding such as SUID support.
      '';
    };
    package = mkPackageOption pkgs "singularity" {
      example = "apptainer";
    };
    packageOverriden = mkOption {
      type = types.nullOr types.package;
      default = null;
      description = mdDoc ''
        This option provides access to the overridden result of `programs.singularity.package`.

        For example, the following configuration makes all the Nixpkgs packages use the overridden `singularity`:
        ```Nix
        { config, lib, pkgs, ... }:
        {
          nixpkgs.overlays = [
            (final: prev: {
              _singularity-orig = prev.singularity;
              singularity = config.programs.singularity.packageOverriden;
            })
          ];
          programs.singularity.enable = true;
          programs.singularity.package = pkgs._singularity-orig;
        }
        ```

        Use `lib.mkForce` to forcefully specify the overridden package.
      '';
    };
    enableExternalLocalStateDir = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = mdDoc ''
        Whether to use top-level directories as LOCALSTATEDIR
        instead of the store path ones.
        This affects the SESSIONDIR of Apptainer/Singularity.
        If set to true, the SESSIONDIR will become
        `/var/lib/''${projectName}/mnt/session`.
      '';
    };
    enableFakeroot = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = mdDoc ''
        Whether to enable the `--fakeroot` support of Singularity/Apptainer.
      '';
    };
    enableSuid = mkOption {
      type = types.bool;
      # SingularityCE requires SETUID for most things. Apptainer prefers user
      # namespaces, e.g. `apptainer exec --nv` would fail if built
      # `--with-suid`:
      # > `FATAL: nvidia-container-cli not allowed in setuid mode`
      default = cfg.package.projectName != "apptainer";
      defaultText = literalExpression ''config.services.singularity.package.projectName != "apptainer"'';
      example = false;
      description = mdDoc ''
        Whether to enable the SUID support of Singularity/Apptainer.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.singularity.packageOverriden = (cfg.package.override (
      optionalAttrs cfg.enableExternalLocalStateDir {
        externalLocalStateDir = "/var/lib";
      } // optionalAttrs cfg.enableFakeroot {
        newuidmapPath = "/run/wrappers/bin/newuidmap";
        newgidmapPath = "/run/wrappers/bin/newgidmap";
      } // optionalAttrs cfg.enableSuid {
        enableSuid = true;
        starterSuidPath = "/run/wrappers/bin/${cfg.package.projectName}-suid";
      }
    ));
    environment.systemPackages = [ cfg.packageOverriden ];
    security.wrappers."${cfg.packageOverriden.projectName}-suid" = mkIf cfg.enableSuid {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${cfg.packageOverriden}/libexec/${cfg.packageOverriden.projectName}/bin/starter-suid.orig";
    };
    systemd.tmpfiles.rules = mkIf cfg.enableExternalLocalStateDir [
      "d /var/lib/${cfg.packageOverriden.projectName}/mnt/session 0770 root root -"
    ];
  };

}
