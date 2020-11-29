{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.url-bot-rs;

  format = pkgs.formats.toml {};
  configFile = format.generate "url-bot-rs.toml" cfg.settings;
in
{
  options.services.url-bot-rs = {
    enable = mkEnableOption "Minimal IRC URL bot in Rust";

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "--verbose" ];
      description = ''
        List of additional command line parameters for url-bot-rs.
      '';
    };

    settings = mkOption {
      type = format.type;
      default = {};
      description = ''
        Configuration for url-bot-rs, see <link xlink:href="https://github.com/nuxeh/url-bot-rs#configuration-file-options"/>
        for supported values.
      '';
    };

    nickname = mkOption {
      type = types.str;
      default = "url-bot-rs";
      example = "urlify";
      description = ''
        Primary nickname of the bot on IRC.
      '';
    };

    server = mkOption {
      type = types.str;
      example = "irc.example.com";
      description = ''
        Hostname of the IRC server to connect to.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 6667;
      example = 6697;
      description = ''
        Port of the IRC server to connect to.
      '';
    };

    ssl = mkOption {
      type = types.bool;
      default = cfg.port == 6697;
      description = ''
        Whether to enable SSL/TLS on the IRC connection.
      '';
    };

    channels = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["#nixos"];
      description = ''
        List of channels the bot joins on connect.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.url-bot-rs.settings = {
      connection = mapAttrs (name: mkDefault) {
        # These are the basic settings required to get the bot connected and joined.
        nickname = cfg.nickname;
        server = cfg.server;
        port = cfg.port;
        use_ssl = cfg.ssl;
        channels = cfg.channels;
      };
    };

    systemd.services.url-bot-rs = {
      description = "Minimal IRC URL bot in Rust";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment.HOME = "/var/lib/url-bot-rs";

      serviceConfig = {
        ExecStart = "${pkgs.url-bot-rs}/bin/url-bot-rs -c ${configFile} " + concatStringsSep " " cfg.extraArgs;
        DynamicUser = true;
        Restart = "always";
        RestartSec = 10;

        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        DeviceAllow = [
          "/dev/stdin"
          "/dev/stdout"
          "/dev/stderr"
        ];
        DevicePolicy = "strict";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateNetwork = false;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        StateDirectory = "url-bot-rs";
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" ];
        UMask = "0177";

      };
    };
  };

  meta.buildDocsInSandbox = false;
}
