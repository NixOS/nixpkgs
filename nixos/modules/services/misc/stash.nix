{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.stash;
  opt = options.services.stash;

in {

  options.services.stash = {
    enable = lib.mkEnableOption "Enable Stash service";

    user = lib.mkOption {
      type = lib.types.str;
      default = "stash";
      description = "User account under which Stash runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "stash";
      description = "Group under which Stash runs.";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "The ip address for the host that stash is listening to.";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 9999;
      description = "The port that stash serves to.";
    };

    externalHost = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Needed in some cases when you use a reverse proxy.";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/stash";
      description = "Path where to store data files.";
    };

    ffmpegPkg = lib.mkOption {
      type = lib.types.package;
      default = pkgs.ffmpeg;
      defaultText = lib.literalExpression "pkgs.ffmpeg";
      description = "FFMpeg package to use.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.stash;
      defaultText = lib.literalExpression "pkgs.stash";
      description = "Stash package to use.";
    };
  };

  config = lib.mkIf cfg.enable (let
    stashPython = pkgs.python3.withPackages (ps: with ps; [
      cloudscraper
      configparser
      # libpath
      progressbar
      requests
      # youtube_dl
    ]);
    stashPackages = with pkgs; [
      stashPython
      bashInteractive
      openssl
      sqlite
      cfg.ffmpegPkg
    ];
  in {
    environment.systemPackages = stashPackages;

    systemd.services.stash = {
      enable = true;
      description = "Stash daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      restartIfChanged = true; # Whether to restart on a nixos-rebuild
      environment = {
        STASH_HOST = cfg.host;
        STASH_PORT = toString cfg.port;
        STASH_EXTERNAL_HOST = toString cfg.externalHost;
      };

      path = stashPackages;

      preStart = ''
        mkdir -p ~/.stash && chmod 777 ~/.stash;
        rm -f ~/.stash/ffmpeg && ln -s ${cfg.ffmpegPkg}/bin/ffmpeg ~/.stash/ffmpeg;
        rm -f ~/.stash/ffprobe && ln -s ${cfg.ffmpegPkg}/bin/ffprobe ~/.stash/ffprobe;
      '';

      script = "${cfg.package}/bin/stash";
      scriptArgs = "--nobrowser";

      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        # User and group
        User = cfg.user;
        Group = cfg.group;
      };
    };

    users.users = lib.mkMerge [
      (lib.mkIf (cfg.user == "stash") {
        stash = {
          isSystemUser = true;
          group = cfg.group;
          home = cfg.dataDir;
          createHome = true;
        };
      })
      (lib.attrsets.setAttrByPath [ cfg.user "packages" ] ([ cfg.package ] ++ stashPackages))
    ];

    users.groups = lib.optionalAttrs (cfg.group == "stash") {
      stash = {
      };
    };
  });
}
