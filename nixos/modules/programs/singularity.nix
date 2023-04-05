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
    package = mkOption {
      type = types.package;
      default = pkgs.singularity;
      defaultText = literalExpression "pkgs.singularity";
      example = literalExpression "pkgs.apptainer";
      description = mdDoc ''
        Singularity/Apptainer package to override and install.
      '';
    };
    packageOverriden = mkOption {
      type = types.nullOr types.package;
      default = null;
      description = mdDoc ''
        This option provides access to the overriden result of `programs.singularity.package`.

        For example, the following configuration makes all the Nixpkgs packages use the overriden `singularity`:
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

        Use `lib.mkForce` to forcefully specify the overriden package.
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
      default = true;
      example = false;
      description = mdDoc ''
        Whether to enable the SUID support of Singularity/Apptainer.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.singularity.packageOverriden = (cfg.package.override (
      optionalAttrs cfg.enableFakeroot {
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
    systemd.tmpfiles.rules = [
      "d /var/lib/${cfg.packageOverriden.projectName}/mnt/session 0770 root root -"
      "d /var/lib/${cfg.packageOverriden.projectName}/mnt/final 0770 root root -"
      "d /var/lib/${cfg.packageOverriden.projectName}/mnt/overlay 0770 root root -"
      "d /var/lib/${cfg.packageOverriden.projectName}/mnt/container 0770 root root -"
      "d /var/lib/${cfg.packageOverriden.projectName}/mnt/source 0770 root root -"
    ];
  };

}
