{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.singularity;
in
{

  options.programs.singularity = {
    enable = lib.mkEnableOption "singularity" // {
      description = ''
        Whether to install Singularity/Apptainer with system-level overriding such as SUID support.
      '';
    };
    package = lib.mkPackageOption pkgs "singularity" { example = "apptainer"; };
    packageOverriden = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = null;
      description = ''
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
    enableExternalLocalStateDir = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = ''
        Whether to use top-level directories as LOCALSTATEDIR
        instead of the store path ones.
        This affects the SESSIONDIR of Apptainer/Singularity.
        If set to true, the SESSIONDIR will become
        `/var/lib/''${projectName}/mnt/session`.
      '';
    };
    enableFakeroot = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to enable the `--fakeroot` support of Singularity/Apptainer.

        This option is deprecated and has no effect.
        `--fakeroot` support is enabled automatically,
        as `systemBinPaths = [ "/run/wrappers/bin" ]` is always specified.
      '';
    };
    enableSuid = lib.mkOption {
      type = lib.types.bool;
      # SingularityCE requires SETUID for most things. Apptainer prefers user
      # namespaces, e.g. `apptainer exec --nv` would fail if built
      # `--with-suid`:
      # > `FATAL: nvidia-container-cli not allowed in setuid mode`
      default = cfg.package.projectName != "apptainer";
      defaultText = lib.literalExpression ''config.services.singularity.package.projectName != "apptainer"'';
      example = false;
      description = ''
        Whether to enable the SUID support of Singularity/Apptainer.
      '';
    };
    systemBinPaths = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = ''
        (Extra) system-wide /**/bin paths
        for Apptainer/Singularity to find command-line utilities in.

        `"/run/wrappers/bin"` is included by default to make
        utilities with SUID bit set available to Apptainer/Singularity.
        Use `lib.mkForce` to shadow the default values.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.singularity.packageOverriden = (
      cfg.package.override (
        {
          systemBinPaths = cfg.systemBinPaths;
        }
        // lib.optionalAttrs cfg.enableExternalLocalStateDir { externalLocalStateDir = "/var/lib"; }
        // lib.optionalAttrs cfg.enableSuid {
          enableSuid = true;
          starterSuidPath = "/run/wrappers/bin/${cfg.package.projectName}-suid";
        }
      )
    );
    programs.singularity.systemBinPaths = [ "/run/wrappers/bin" ];
    environment.systemPackages = [ cfg.packageOverriden ];
    security.wrappers."${cfg.packageOverriden.projectName}-suid" = lib.mkIf cfg.enableSuid {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${cfg.packageOverriden}/libexec/${cfg.packageOverriden.projectName}/bin/starter-suid.orig";
    };
    systemd.tmpfiles.rules = lib.mkIf cfg.enableExternalLocalStateDir [
      "d /var/lib/${cfg.packageOverriden.projectName}/mnt/session 0770 root root -"
    ];
  };
}
