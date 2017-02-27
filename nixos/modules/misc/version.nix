{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.system;

  releaseFile  = "${toString pkgs.path}/.version";
  suffixFile   = "${toString pkgs.path}/.version-suffix";
  revisionFile = "${toString pkgs.path}/.git-revision";
  gitRepo      = "${toString pkgs.path}/.git";
  gitCommitId  = lib.substring 0 7 (commitIdFromGitRepo gitRepo);
in

{

  options.system = {

    stateVersion = mkOption {
      type = types.str;
      default = cfg.nixosRelease;
      description = ''
        Every once in a while, a new NixOS release may change
        configuration defaults in a way incompatible with stateful
        data. For instance, if the default version of PostgreSQL
        changes, the new version will probably be unable to read your
        existing databases. To prevent such breakage, you can set the
        value of this option to the NixOS release with which you want
        to be compatible. The effect is that NixOS will option
        defaults corresponding to the specified release (such as using
        an older version of PostgreSQL).
      '';
    };

    nixosLabel = mkOption {
      type = types.str;
      description = ''
        Label to be used in the names of generated outputs and boot
        labels.
      '';
    };

    nixosVersion = mkOption {
      internal = true;
      type = types.str;
      description = "The full NixOS version (e.g. <literal>16.03.1160.f2d4ee1</literal>).";
    };

    nixosRelease = mkOption {
      readOnly = true;
      type = types.str;
      default = fileContents releaseFile;
      description = "The NixOS release (e.g. <literal>16.03</literal>).";
    };

    nixosVersionSuffix = mkOption {
      internal = true;
      type = types.str;
      default = if pathExists suffixFile then fileContents suffixFile else "pre-git";
      description = "The NixOS version suffix (e.g. <literal>1160.f2d4ee1</literal>).";
    };

    nixosRevision = mkOption {
      internal = true;
      type = types.str;
      default = if pathIsDirectory gitRepo then commitIdFromGitRepo gitRepo
                else if pathExists revisionFile then fileContents revisionFile
                else "master";
      description = "The Git revision from which this NixOS configuration was built.";
    };

    nixosCodeName = mkOption {
      readOnly = true;
      type = types.str;
      description = "The NixOS release code name (e.g. <literal>Emu</literal>).";
    };

    defaultChannel = mkOption {
      internal = true;
      type = types.str;
      default = https://nixos.org/channels/nixos-unstable;
      description = "Default NixOS channel to which the root user is subscribed.";
    };

  };

  config = {

    system = {
      # These defaults are set here rather than up there so that
      # changing them would not rebuild the manual
      nixosLabel   = mkDefault cfg.nixosVersion;
      nixosVersion = mkDefault (cfg.nixosRelease + cfg.nixosVersionSuffix);
      nixosRevision      = mkIf (pathIsDirectory gitRepo) (mkDefault            gitCommitId);
      nixosVersionSuffix = mkIf (pathIsDirectory gitRepo) (mkDefault (".git." + gitCommitId));

      # Note: code names must only increase in alphabetical order.
      nixosCodeName = "Hummingbird";
    };

    # Generate /etc/os-release.  See
    # https://www.freedesktop.org/software/systemd/man/os-release.html for the
    # format.
    environment.etc."os-release".text =
      ''
        NAME=NixOS
        ID=nixos
        VERSION="${config.system.nixosVersion} (${config.system.nixosCodeName})"
        VERSION_CODENAME=${toLower config.system.nixosCodeName}
        VERSION_ID="${config.system.nixosVersion}"
        PRETTY_NAME="NixOS ${config.system.nixosVersion} (${config.system.nixosCodeName})"
        HOME_URL="https://nixos.org/"
        SUPPORT_URL="https://nixos.org/nixos/support.html"
        BUG_REPORT_URL="https://github.com/NixOS/nixpkgs/issues"
      '';

  };

}
