{ config, lib, pkgs, ... }:

with pkgs;
with lib;

let
  uid = config.ids.uids.mopidy;
  gid = config.ids.gids.mopidy;
  cfg = config.services.mopidy;

  mopidyConf = writeText "mopidy.conf" cfg.configuration;

  mopidyEnv = buildEnv {
    name = "mopidy-with-extensions-${mopidy.version}";
    paths = closePropagation cfg.extensionPackages;
    pathsToLink = [ "/${python3.sitePackages}" ];
    buildInputs = [ makeWrapper ];
    postBuild = ''
      makeWrapper ${mopidy}/bin/mopidy $out/bin/mopidy \
        --prefix PYTHONPATH : $out/${python3.sitePackages}
    '';
  };
in {

  options = {

    services.mopidy = {

      enable = mkEnableOption "Mopidy, a music player daemon";

      dataDir = mkOption {
        default = "/var/lib/mopidy";
        type = types.str;
        description = ''
          The directory where Mopidy stores its state.
        '';
      };

      extensionPackages = mkOption {
        default = [];
        type = types.listOf types.package;
        example = literalExample "[ pkgs.mopidy-spotify ]";
        description = ''
          Mopidy extensions that should be loaded by the service.
        '';
      };

      configuration = mkOption {
        default = "";
        type = types.lines;
        description = ''
          The configuration that Mopidy should use.
        '';
      };

      extraConfigFiles = mkOption {
        default = [];
        type = types.listOf types.str;
        description = ''
          Extra config file read by Mopidy when the service starts.
          Later files in the list overrides earlier configuration.
        '';
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' - mopidy mopidy - -"
    ];

    systemd.services.mopidy = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "sound.target" ];
      description = "mopidy music player daemon";
      serviceConfig = {
        ExecStart = "${mopidyEnv}/bin/mopidy --config ${concatStringsSep ":" ([mopidyConf] ++ cfg.extraConfigFiles)}";
        User = "mopidy";
      };
    };

    systemd.services.mopidy-scan = {
      description = "mopidy local files scanner";
      serviceConfig = {
        ExecStart = "${mopidyEnv}/bin/mopidy --config ${concatStringsSep ":" ([mopidyConf] ++ cfg.extraConfigFiles)} local scan";
        User = "mopidy";
        Type = "oneshot";
      };
    };

    users.users.mopidy = {
      inherit uid;
      group = "mopidy";
      extraGroups = [ "audio" ];
      description = "Mopidy daemon user";
      home = cfg.dataDir;
    };

    users.groups.mopidy.gid = gid;

  };

}
