{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.stash;
  opt = options.services.stash;

in
{

  options.services.stash = {
    enable = mkEnableOption (mdDoc "Stash");

    user = mkOption {
      type = types.str;
      default = "stash";
      description = mdDoc "User account under which Stash runs.";
    };

    group = mkOption {
      type = types.str;
      default = "stash";
      description = mdDoc "Group under which Stash runs.";
    };

    host = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = mdDoc "The ip address for the host that stash is listening to.";
    };

    port = mkOption {
      type = types.port;
      default = 9999;
      description = mdDoc "The port that stash serves to.";
    };

    externalHost = mkOption {
      type = types.str;
      default = "";
      description = mdDoc "Needed in some cases when you use a reverse proxy.";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/stash";
      description = mdDoc "Path where to store data files.";
    };

    package = mkPackageOptionMD pkgs "stash" {};
};

  config = mkIf cfg.enable (
    let
      stashPython = pkgs.python3.withPackages (ps: with ps; [
        cloudscraper
        configparser
        progressbar
        requests
      ]);
      stashPackages = with pkgs; [
        stashPython
        bashInteractive
        openssl
        sqlite
        ffmpeg
      ];
    in
    {
      systemd.services.stash = {
        description = mdDoc "Stash daemon";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        environment = {
          HOME = "%S/stash";
          STASH_HOST = cfg.host;
          STASH_PORT = toString cfg.port;
          STASH_EXTERNAL_HOST = toString cfg.externalHost;
        };

        path = stashPackages;

        preStart = ''
          mkdir -p ~/.stash && chmod 0700 ~/.stash;
          rm -f ~/.stash/ffmpeg && ln -s ${cfg.ffmpegPkg}/bin/ffmpeg ~/.stash/ffmpeg;
          rm -f ~/.stash/ffprobe && ln -s ${cfg.ffmpegPkg}/bin/ffprobe ~/.stash/ffprobe;
        '';

        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          DynamicUser = true;
          StateDirectory = "stash";
          ExecStart = "${cfg.package}/bin/stash --nowbrowser";
        };
      };

      users.users = mkMerge [
        (mkIf (cfg.user == "stash") {
          stash = {
            isSystemUser = true;
            group = cfg.group;
            home = cfg.dataDir;
            createHome = true;
          };
        })
        (attrsets.setAttrByPath [ cfg.user "packages" ] ([ cfg.package ] ++ stashPackages))
      ];

      users.groups = optionalAttrs (cfg.group == "stash") {
        stash = { };
      };
    }
  );
}
