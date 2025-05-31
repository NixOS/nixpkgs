{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.encrypted-dns-server;
in
{
  options.services.encrypted-dns-server = {
    enable = lib.mkEnableOption "encrypted-dns-server";
    package = lib.mkPackageOption pkgs "encrypted-dns-server" { };

    settings = lib.mkOption {
      description = ''
        Attrset that is converted and passed as TOML config file.
        For available params, see: <https://github.com/DNSCrypt/encrypted-dns-server/blob/${pkgs.encrypted-dns-server.version}/example-encrypted-dns.toml>
      '';
      example = lib.literalExpression ''
        {
         state_file = "/var/lib/encrypted-dns-server/encrypted-dns.state";
         upstream_addr = "1.1.1.1:53";
         listen_addrs = [
           {
             local = "127.0.0.1:5443";
             external = "127.0.0.1:5443";
           }
         ];
        }
      '';
      type = lib.types.attrs;
      default = { };
    };

    upstreamDefaults = lib.mkOption {
      description = ''
        Whether to base the config declared in {option}`services.encrypted-dns-server.settings` on the upstream example config (<https://raw.githubusercontent.com/DNSCrypt/encrypted-dns-server/refs/heads/master/example-encrypted-dns.toml>)

        Disable this if you want to declare your dnscrypt config from scratch.
      '';
      type = lib.types.bool;
      default = true;
    };

    configFile = lib.mkOption {
      description = ''
        Path to TOML config file. See: <https://raw.githubusercontent.com/DNSCrypt/encrypted-dns-server/refs/heads/master/example-encrypted-dns.toml>
        If this option is set, it will override any configuration done in options.services.encrypted-dns-server.settings.
      '';
      example = "/etc/encrypted-dns-server/config.toml";
      type = lib.types.path;
      default =
        pkgs.runCommand "encrypted-dns-server.toml"
          {
            json = builtins.toJSON cfg.settings;
            passAsFile = [ "json" ];
          }
          ''
            ${
              if cfg.upstreamDefaults then
                ''
                  ${pkgs.buildPackages.remarshal}/bin/toml2json ${pkgs.encrypted-dns-server.src}/example-encrypted-dns.toml > example.json
                  ${pkgs.buildPackages.jq}/bin/jq --slurp add example.json $jsonPath > config.json # merges the two
                ''
              else
                ''
                  cp $jsonPath config.json
                ''
            }
            ${pkgs.buildPackages.remarshal}/bin/json2toml < config.json > $out
          '';
      defaultText = lib.literalMD "TOML file generated from {option}`services.encrypted-dns-server.settings`";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.encrypted-dns-server = {
      description = "encrypted dns server";
      wants = [
        "network-online.target"
        "nss-lookup.target"
      ];
      before = [ "nss-lookup.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        CacheDirectory = "encrypted-dns-server";
        DynamicUser = true;
        ExecStart = "${pkgs.encrypted-dns-server}/bin/encrypted-dns --config ${cfg.configFile}";
        LockPersonality = true;
        LogsDirectory = "encrypted-dns-server";
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
        RestartSec = 30;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RuntimeDirectory = "encrypted-dns-server";
        StateDirectory = "encrypted-dns-server";
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

  meta.buildDocsInSandbox = false;
}
