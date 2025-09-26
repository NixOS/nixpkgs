{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.dnscrypt-proxy;

in

{
  imports = [
    (lib.mkRenamedOptionModule [ "services" "dnscrypt-proxy2" ] [ "services" "dnscrypt-proxy" ])
  ];

  options.services.dnscrypt-proxy = {
    enable = lib.mkEnableOption "dnscrypt-proxy";

    package = lib.mkPackageOption pkgs "dnscrypt-proxy" { };

    settings = lib.mkOption {
      description = ''
        Attrset that is converted and passed as TOML config file.
        For available params, see: <https://github.com/DNSCrypt/dnscrypt-proxy/blob/${pkgs.dnscrypt-proxy.version}/dnscrypt-proxy/example-dnscrypt-proxy.toml>
      '';
      example = lib.literalExpression ''
        {
          sources.public-resolvers = {
            urls = [ "https://download.dnscrypt.info/resolvers-list/v2/public-resolvers.md" ];
            cache_file = "public-resolvers.md";
            minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
            refresh_delay = 72;
          };
        }
      '';
      type = lib.types.attrs;
      default = { };
    };

    upstreamDefaults = lib.mkOption {
      description = ''
        Whether to base the config declared in {option}`services.dnscrypt-proxy.settings` on the upstream example config (<https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-dnscrypt-proxy.toml>)

        Disable this if you want to declare your dnscrypt config from scratch.
      '';
      type = lib.types.bool;
      default = true;
    };

    configFile = lib.mkOption {
      description = ''
        Path to TOML config file. See: <https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-dnscrypt-proxy.toml>
        If this option is set, it will override any configuration done in options.services.dnscrypt-proxy.settings.
      '';
      example = "/etc/dnscrypt-proxy/dnscrypt-proxy.toml";
      type = lib.types.path;
      default =
        pkgs.runCommand "dnscrypt-proxy.toml"
          {
            json = builtins.toJSON cfg.settings;
            passAsFile = [ "json" ];
          }
          ''
            ${
              if cfg.upstreamDefaults then
                ''
                  ${pkgs.buildPackages.remarshal}/bin/toml2json ${pkgs.dnscrypt-proxy.src}/dnscrypt-proxy/example-dnscrypt-proxy.toml > example.json
                  ${pkgs.buildPackages.jq}/bin/jq --slurp add example.json $jsonPath > config.json # merges the two
                ''
              else
                ''
                  cp $jsonPath config.json
                ''
            }
            ${pkgs.buildPackages.remarshal}/bin/json2toml < config.json > $out
          '';
      defaultText = lib.literalMD "TOML file generated from {option}`services.dnscrypt-proxy.settings`";
    };
  };

  config = lib.mkIf cfg.enable {

    networking.nameservers = lib.mkDefault [ "127.0.0.1" ];

    systemd.services.dnscrypt-proxy = {
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
      aliases = [ "dnscrypt-proxy2.service" ];
      serviceConfig = {
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        CacheDirectory = "dnscrypt-proxy";
        DynamicUser = true;
        ExecStart = "${lib.getExe cfg.package} -config ${cfg.configFile}";
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
          "~@setuid"
          "~@timer"
        ];
      };
    };
  };

  # uses attributes of the linked package
  meta.buildDocsInSandbox = false;
}
