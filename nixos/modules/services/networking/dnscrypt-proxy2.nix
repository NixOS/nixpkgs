{ config, lib, pkgs, ... }: with lib;

let
  cfg = config.services.dnscrypt-proxy2;
in

{
  options.services.dnscrypt-proxy2 = {
    enable = mkEnableOption (lib.mdDoc "dnscrypt-proxy2");

    settings = mkOption {
      description = lib.mdDoc ''
        Attrset that is converted and passed as TOML config file.
        For available params, see: <https://github.com/DNSCrypt/dnscrypt-proxy/blob/${pkgs.dnscrypt-proxy2.version}/dnscrypt-proxy/example-dnscrypt-proxy.toml>
      '';
      example = literalExpression ''
        {
          sources.public-resolvers = {
            urls = [ "https://download.dnscrypt.info/resolvers-list/v2/public-resolvers.md" ];
            cache_file = "public-resolvers.md";
            minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
            refresh_delay = 72;
          };
        }
      '';
      type = types.attrs;
      default = {};
    };

    upstreamDefaults = mkOption {
      description = lib.mdDoc ''
        Whether to base the config declared in {option}`services.dnscrypt-proxy2.settings` on the upstream example config (<https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-dnscrypt-proxy.toml>)

        Disable this if you want to declare your dnscrypt config from scratch.
      '';
      type = types.bool;
      default = true;
    };

    configFile = mkOption {
      description = lib.mdDoc ''
        Path to TOML config file. See: <https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-dnscrypt-proxy.toml>
        If this option is set, it will override any configuration done in options.services.dnscrypt-proxy2.settings.
      '';
      example = "/etc/dnscrypt-proxy/dnscrypt-proxy.toml";
      type = types.path;
      default = pkgs.runCommand "dnscrypt-proxy.toml" {
        json = builtins.toJSON cfg.settings;
        passAsFile = [ "json" ];
      } ''
        ${if cfg.upstreamDefaults then ''
          ${pkgs.remarshal}/bin/toml2json ${pkgs.dnscrypt-proxy2.src}/dnscrypt-proxy/example-dnscrypt-proxy.toml > example.json
          ${pkgs.jq}/bin/jq --slurp add example.json $jsonPath > config.json # merges the two
        '' else ''
          cp $jsonPath config.json
        ''}
        ${pkgs.remarshal}/bin/json2toml < config.json > $out
      '';
      defaultText = literalMD "TOML file generated from {option}`services.dnscrypt-proxy2.settings`";
    };
  };

  config = mkIf cfg.enable {

    networking.nameservers = lib.mkDefault [ "127.0.0.1" ];

    systemd.services.dnscrypt-proxy2 = {
      description = "DNSCrypt-proxy client";
      wants = [
        "network-online.target"
        "nss-lookup.target"
      ];
      before = [
        "nss-lookup.target"
      ];
      wantedBy = [
        "multi-user.target"
      ];
      serviceConfig = {
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        CacheDirectory = "dnscrypt-proxy";
        DynamicUser = true;
        ExecStart = "${pkgs.dnscrypt-proxy2}/bin/dnscrypt-proxy -config ${cfg.configFile}";
        LockPersonality = true;
        LogsDirectory = "dnscrypt-proxy";
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        NonBlocking = true;
        PrivateDevices = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        Restart = "always";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RuntimeDirectory = "dnscrypt-proxy";
        StateDirectory = "dnscrypt-proxy";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "@chown"
          "~@aio"
          "~@keyring"
          "~@memlock"
          "~@resources"
          "~@setuid"
          "~@timer"
        ];
      };
    };
  };

  # uses attributes of the linked package
  meta.buildDocsInSandbox = false;
}
