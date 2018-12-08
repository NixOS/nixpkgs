{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.vdr;

  libDir = "/var/lib/vdr";
in {

  ###### interface

  options = {

    services.vdr = {
      enable = mkEnableOption "VDR";

      package = mkOption {
        type = types.package;
        default = pkgs.vdr-with-plugins;
        description = "Package to use.";
      };

      shutdown = mkOption {
        type = types.path;
        default = pkgs.writeScript "vdr-shutdown" ''
          #!${pkgs.stdenv.shell} -eu
          next="$2"
          if [ "$next" -eq 0 ]; then # no timer
            next=86400 # one day
          elif [ "$next" -lt 0 ]; then # recording is running
            next=60 # one minute
          fi
          /run/wrappers/bin/sudo ${pkgs.utillinux}/bin/rtcwake -m off -s "$next"
          '';
        description = "Shutdown command";
      };

      videoDir = mkOption {
        type = types.path;
        default = "/srv/vdr/video";
        description = "Recording directory";
      };

      extraArguments = mkOption {
        type = types.str;
        default = "";
        description = "Additional command line arguments to pass to VDR.";
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    system.activationScripts.vdr = ''
      if ! [ -d /var/cache/vdr ]; then
        mkdir -p /var/cache/vdr
        chown vdr:vdr /var/cache/vdr
      fi

      if ! [ -d "${libDir}" ]; then
        mkdir -p "${libDir}"
        cp --dereference -r "${cfg.package}"/share/vdr/conf/* "${libDir}"
        chown -R vdr:vdr "${libDir}"
      fi

      if ! [ -d "${cfg.videoDir}" ]; then
        mkdir -p "${cfg.videoDir}"
        chown vdr:vdr "${cfg.videoDir}"
      fi
    '';

    security.sudo.configFile = ''
      vdr ALL=(root) NOPASSWD:${pkgs.utillinux}/bin/rtcwake
    '';

    systemd.services.vdr = {
      description = "VDR";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/vdr --shutdown=\"${cfg.shutdown}\" --video=\"${cfg.videoDir}\" ${cfg.extraArguments}";
        User = "vdr";

        Restart = "on-failure";
      };
    };

    users.extraUsers.vdr = {
      uid = config.ids.uids.vdr;
      group = "vdr";
      home = libDir;
    };

    users.groups.vdr.gid = config.ids.gids.vdr;
  };
}
