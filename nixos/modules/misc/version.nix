{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.system.nixos;

  gitRepo      = "${toString pkgs.path}/.git";
  gitCommitId  = lib.substring 0 7 (commitIdFromGitRepo gitRepo);
in

{

  options.system = {

    nixos.version = mkOption {
      internal = true;
      type = types.str;
      description = "The full NixOS version (e.g. <literal>16.03.1160.f2d4ee1</literal>).";
    };

    nixos.release = mkOption {
      readOnly = true;
      type = types.str;
      default = trivial.release;
      description = "The NixOS release (e.g. <literal>16.03</literal>).";
    };

    nixos.versionSuffix = mkOption {
      internal = true;
      type = types.str;
      default = trivial.versionSuffix;
      description = "The NixOS version suffix (e.g. <literal>1160.f2d4ee1</literal>).";
    };

    nixos.revision = mkOption {
      internal = true;
      type = types.str;
      default = trivial.revisionWithDefault "master";
      description = "The Git revision from which this NixOS configuration was built.";
    };

    nixos.codeName = mkOption {
      readOnly = true;
      type = types.str;
      default = trivial.codeName;
      description = "The NixOS release code name (e.g. <literal>Emu</literal>).";
    };

    stateVersion = mkOption {
      type = types.str;
      # Deliberately no default, as automatically upgrading the stateVersion can
      # lead systems to stop working.
      example = cfg.release;
      description = ''
        This option exists to prevent breakage for NixOS modules that depend on
        state which can't be controlled by them. The value of this option
        represents the <em>initial</em> NixOS version installed, and should
        therefore <em>not</em> be ever changed unless you make sure to run all
        necessary migrations yourself. By fixing this value, NixOS modules can
        know what version your state is in, such that they can make incompatible
        changes for new installations, without breaking the module for all
        existing installations. For example this is used in the postgresql
        module, where a new module version uses a newer postgresql version which
        can't read the databases of older versions.
      '';
    };

    defaultChannel = mkOption {
      internal = true;
      type = types.str;
      default = https://nixos.org/channels/nixos-unstable;
      description = "Default NixOS channel to which the root user is subscribed.";
    };

  };

  config = {

    system.nixos = {
      # These defaults are set here rather than up there so that
      # changing them would not rebuild the manual
      version = mkDefault (cfg.release + cfg.versionSuffix);
      revision      = mkIf (pathIsDirectory gitRepo) (mkDefault            gitCommitId);
      versionSuffix = mkIf (pathIsDirectory gitRepo) (mkDefault (".git." + gitCommitId));
    };

    # Generate /etc/os-release.  See
    # https://www.freedesktop.org/software/systemd/man/os-release.html for the
    # format.
    environment.etc."os-release".text =
      ''
        NAME=NixOS
        ID=nixos
        VERSION="${cfg.version} (${cfg.codeName})"
        VERSION_CODENAME=${toLower cfg.codeName}
        VERSION_ID="${cfg.version}"
        PRETTY_NAME="NixOS ${cfg.version} (${cfg.codeName})"
        LOGO="nix-snowflake"
        HOME_URL="https://nixos.org/"
        DOCUMENTATION_URL="https://nixos.org/nixos/manual/index.html"
        SUPPORT_URL="https://nixos.org/nixos/support.html"
        BUG_REPORT_URL="https://github.com/NixOS/nixpkgs/issues"
      '';

  };

}
