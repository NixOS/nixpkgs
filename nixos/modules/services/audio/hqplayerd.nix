{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.hqplayerd;
  pkg = pkgs.hqplayerd;
  # XXX: This is hard-coded in the distributed binary, don't try to change it.
  stateDir = "/var/lib/hqplayer";
  configDir = "/etc/hqplayer";
in
{
  options = {
    services.hqplayerd = {
      enable = mkEnableOption (lib.mdDoc "HQPlayer Embedded");

      auth = {
        username = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            Username used for HQPlayer's WebUI.

            Without this you will need to manually create the credentials after
            first start by going to http://your.ip/8088/auth
          '';
        };

        password = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            Password used for HQPlayer's WebUI.

            Without this you will need to manually create the credentials after
            first start by going to http://your.ip/8088/auth
          '';
        };
      };

      licenseFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc ''
          Path to the HQPlayer license key file.

          Without this, the service will run in trial mode and restart every 30
          minutes.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Opens ports needed for the WebUI and controller API.
        '';
      };

      config = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = lib.mdDoc ''
          HQplayer daemon configuration, written to /etc/hqplayer/hqplayerd.xml.

          Refer to share/doc/hqplayerd/readme.txt in the hqplayerd derivation for possible values.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.auth.username != null -> cfg.auth.password != null)
                 && (cfg.auth.password != null -> cfg.auth.username != null);
        message = "You must set either both services.hqplayer.auth.username and password, or neither.";
      }
    ];

    environment = {
      etc = {
        "hqplayer/hqplayerd.xml" = mkIf (cfg.config != null) { source = pkgs.writeText "hqplayerd.xml" cfg.config; };
        "hqplayer/hqplayerd4-key.xml" = mkIf (cfg.licenseFile != null) { source = cfg.licenseFile; };
        "modules-load.d/taudio2.conf".source = "${pkg}/etc/modules-load.d/taudio2.conf";
      };
      systemPackages = [ pkg ];
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 8088 4321 ];
    };

    services.udev.packages = [ pkg ];

    systemd = {
      tmpfiles.rules = [
        "d ${configDir}      0755 hqplayer hqplayer - -"
        "d ${stateDir}       0755 hqplayer hqplayer - -"
        "d ${stateDir}/home  0755 hqplayer hqplayer - -"
      ];

      packages = [ pkg ];

      services.hqplayerd = {
        wantedBy = [ "multi-user.target" ];
        after = [ "systemd-tmpfiles-setup.service" ];

        environment.HOME = "${stateDir}/home";

        unitConfig.ConditionPathExists = [ configDir stateDir ];

        restartTriggers = optionals (cfg.config != null) [ config.environment.etc."hqplayer/hqplayerd.xml".source ];

        preStart = ''
          cp -r "${pkg}/var/lib/hqplayer/web" "${stateDir}"
          chmod -R u+wX "${stateDir}/web"

          if [ ! -f "${configDir}/hqplayerd.xml" ]; then
            echo "creating initial config file"
            install -m 0644 "${pkg}/etc/hqplayer/hqplayerd.xml" "${configDir}/hqplayerd.xml"
          fi
        '' + optionalString (cfg.auth.username != null && cfg.auth.password != null) ''
          ${pkg}/bin/hqplayerd -s ${cfg.auth.username} ${cfg.auth.password}
        '';
      };
    };

    users.groups = {
      hqplayer.gid = config.ids.gids.hqplayer;
    };

    users.users = {
      hqplayer = {
        description = "hqplayer daemon user";
        extraGroups = [ "audio" "video" ];
        group = "hqplayer";
        uid = config.ids.uids.hqplayer;
      };
    };
  };
}
