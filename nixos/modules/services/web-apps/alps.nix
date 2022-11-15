{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.services.alps;
in {
  options.services.alps = {
    enable = mkEnableOption (lib.mdDoc "alps");

    port = mkOption {
      type = types.port;
      default = 1323;
      description = lib.mdDoc ''
        TCP port the service should listen on.
      '';
    };

    bindIP = mkOption {
      default = "[::]";
      type = types.str;
      description = lib.mdDoc ''
        The IP the service should listen on.
      '';
    };

    theme = mkOption {
      type = types.enum [ "alps" "sourcehut" ];
      default = "sourcehut";
      description = lib.mdDoc ''
        The frontend's theme to use.
      '';
    };

    imaps = {
      port = mkOption {
        type = types.port;
        default = 993;
        description = lib.mdDoc ''
          The IMAPS server port.
        '';
      };

      host = mkOption {
        type = types.str;
        default = "[::1]";
        example = "mail.example.org";
        description = lib.mdDoc ''
          The IMAPS server address.
        '';
      };
    };

    smtps = {
      port = mkOption {
        type = types.port;
        default = 465;
        description = lib.mdDoc ''
          The SMTPS server port.
        '';
      };

      host = mkOption {
        type = types.str;
        default = cfg.imaps.host;
        defaultText = "services.alps.imaps.host";
        example = "mail.example.org";
        description = lib.mdDoc ''
          The SMTPS server address.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.alps = {
      description = "alps is a simple and extensible webmail.";
      documentation = [ "https://git.sr.ht/~migadu/alps" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "network-online.target" ];

      serviceConfig = {
        ExecStart = ''
          ${pkgs.alps}/bin/alps \
            -addr ${cfg.bindIP}:${toString cfg.port} \
            -theme ${cfg.theme} \
            imaps://${cfg.imaps.host}:${toString cfg.imaps.port} \
            smpts://${cfg.smtps.host}:${toString cfg.smtps.port}
        '';
        StateDirectory = "alps";
        WorkingDirectory = "/var/lib/alps";
        DynamicUser = true;
      };
    };
  };
}
