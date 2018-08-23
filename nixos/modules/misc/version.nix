{ options, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.system.nixos;

  revisionFile = "${toString pkgs.path}/.git-revision";
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
      default = if pathIsDirectory gitRepo then commitIdFromGitRepo gitRepo
                else if pathExists revisionFile then fileContents revisionFile
                else "master";
      description = "The Git revision from which this NixOS configuration was built.";
    };

    nixos.codeName = mkOption {
      readOnly = true;
      type = types.str;
      description = "The NixOS release code name (e.g. <literal>Emu</literal>).";
    };

    stateVersion = mkOption {
      type = types.str;
      default = cfg.release;
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

      # Note: the first letter is bumped on every release.  It's an animal.
      codeName = "Jellyfish";
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
        HOME_URL="https://nixos.org/"
        SUPPORT_URL="https://nixos.org/nixos/support.html"
        BUG_REPORT_URL="https://github.com/NixOS/nixpkgs/issues"
      '';

  };

}
