{ config, lib, pkgs, ... }:

with pkgs;
with lib;

let

  uid = config.ids.uids.mopidy;
  gid = config.ids.gids.mopidy;
  cfg = config.services.mopidy;

  mopidyConf = writeText "mopidy.conf" cfg.configuration;

  mopidyLauncher = stdenv.mkDerivation {
    name = "mopidy-launcher";
    phases = [ "installPhase" ];
    buildInputs = [ makeWrapper python ];
    installPhase = ''
      mkdir -p $out/bin
      ln -s ${mopidy}/bin/mopidy $out/bin/mopidy
      wrapProgram $out/bin/mopidy \
        --prefix PYTHONPATH : \
        "${concatStringsSep ":" (map (p: "$(toPythonPath ${p})") cfg.extensionPackages)}"
    '';
  };

in {

  options = {

    services.mopidy = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to enable Mopidy, a music player daemon.
        '';
      };

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
        example = [ mopidy-spotify ];
        description = ''
          Mopidy extensions that should be loaded by the service.
        '';
      };

      configuration = mkOption {
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

    systemd.services.mopidy = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "sound.target" ];
      description = "mopidy music player daemon";
      preStart = "mkdir -p ${cfg.dataDir} && chown -R mopidy:mopidy  ${cfg.dataDir}";
      serviceConfig = {
        ExecStart = "${mopidyLauncher}/bin/mopidy --config ${concatStringsSep ":" ([mopidyConf] ++ cfg.extraConfigFiles)}";
        User = "mopidy";
        PermissionsStartOnly = true;
      };
    };

    systemd.services.mopidy-scan = {
      description = "mopidy local files scanner";
      preStart = "mkdir -p ${cfg.dataDir} && chown -R mopidy:mopidy  ${cfg.dataDir}";
      serviceConfig = {
        ExecStart = "${mopidyLauncher}/bin/mopidy --config ${concatStringsSep ":" ([mopidyConf] ++ cfg.extraConfigFiles)} local scan";
        User = "mopidy";
        PermissionsStartOnly = true;
        Type = "oneshot";
      };
    };

    users.extraUsers.mopidy = {
      inherit uid;
      group = "mopidy";
      extraGroups = [ "audio" ];
      description = "Mopidy daemon user";
      home = "${cfg.dataDir}";
    };

    users.extraGroups.mopidy.gid = gid;

  };

}
