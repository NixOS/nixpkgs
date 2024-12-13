{
  config,
  lib,
  pkgs,
  ...
}:
let
  uid = config.ids.uids.mopidy;
  gid = config.ids.gids.mopidy;
  cfg = config.services.mopidy;

  mopidyConf = pkgs.writeText "mopidy.conf" cfg.configuration;

  mopidyEnv = pkgs.buildEnv {
    name = "mopidy-with-extensions-${pkgs.mopidy.version}";
    ignoreCollisions = true;
    paths = lib.closePropagation cfg.extensionPackages;
    pathsToLink = [ "/${pkgs.mopidyPackages.python.sitePackages}" ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      makeWrapper ${lib.getExe pkgs.mopidy} $out/bin/mopidy \
        --prefix PYTHONPATH : $out/${pkgs.mopidyPackages.python.sitePackages}
    '';
  };
in
{

  options = {

    services.mopidy = {

      enable = lib.mkEnableOption "Mopidy, a music player daemon";

      dataDir = lib.mkOption {
        default = "/var/lib/mopidy";
        type = lib.types.str;
        description = ''
          The directory where Mopidy stores its state.
        '';
      };

      extensionPackages = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.package;
        example = lib.literalExpression "[ pkgs.mopidy-spotify ]";
        description = ''
          Mopidy extensions that should be loaded by the service.
        '';
      };

      configuration = lib.mkOption {
        default = "";
        type = lib.types.lines;
        description = ''
          The configuration that Mopidy should use.
        '';
      };

      extraConfigFiles = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.str;
        description = ''
          Extra config file read by Mopidy when the service starts.
          Later files in the list overrides earlier configuration.
        '';
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    systemd.tmpfiles.settings."10-mopidy".${cfg.dataDir}.d = {
      user = "mopidy";
      group = "mopidy";
    };

    systemd.services.mopidy = {
      wantedBy = [ "multi-user.target" ];
      after = [
        "network-online.target"
        "sound.target"
      ];
      wants = [ "network-online.target" ];
      description = "mopidy music player daemon";
      serviceConfig = {
        ExecStart = "${mopidyEnv}/bin/mopidy --config ${
          lib.concatStringsSep ":" ([ mopidyConf ] ++ cfg.extraConfigFiles)
        }";
        Restart = "on-failure";
        User = "mopidy";
      };
    };

    systemd.services.mopidy-scan = {
      description = "mopidy local files scanner";
      serviceConfig = {
        ExecStart = "${mopidyEnv}/bin/mopidy --config ${
          lib.concatStringsSep ":" ([ mopidyConf ] ++ cfg.extraConfigFiles)
        } local scan";
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
