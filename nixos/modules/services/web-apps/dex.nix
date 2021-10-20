{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dex;
  fixClient = client: if client ? secretFile then ((builtins.removeAttrs client [ "secretFile" ]) // { secret = client.secretFile; }) else client;
  filteredSettings = mapAttrs (n: v: if n == "staticClients" then (builtins.map fixClient v) else v) cfg.settings;
  secretFiles = flatten (builtins.map (c: if c ? secretFile then [ c.secretFile ] else []) (cfg.settings.staticClients or []));

  settingsFormat = pkgs.formats.yaml {};
  configFile = settingsFormat.generate "config.yaml" filteredSettings;

  startPreScript = pkgs.writeShellScript "dex-start-pre" (''
  '' + (concatStringsSep "\n" (builtins.map (file: ''
    ${pkgs.replace-secret}/bin/replace-secret '${file}' '${file}' /run/dex/config.yaml
  '') secretFiles)));
in
{
  options.services.dex = {
    enable = mkEnableOption "the OpenID Connect and OAuth2 identity provider";

    settings = mkOption {
      type = settingsFormat.type;
      default = {};
      example = literalExpression ''
        {
          # External url
          issuer = "http://127.0.0.1:5556/dex";
          storage = {
            type = "postgres";
            config.host = "/var/run/postgres";
          };
          web = {
            http = "127.0.0.1:5556";
          };
          enablePasswordDB = true;
          staticClients = [
            {
              id = "oidcclient";
              name = "Client";
              redirectURIs = [ "https://example.com/callback" ];
              secretFile = "/etc/dex/oidcclient"; # The content of `secretFile` will be written into to the config as `secret`.
            }
          ];
        }
      '';
      description = ''
        The available options can be found in
        <link xlink:href="https://github.com/dexidp/dex/blob/v${pkgs.dex.version}/config.yaml.dist">the example configuration</link>.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.dex = {
      description = "dex identity provider";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ] ++ (optional (cfg.settings.storage.type == "postgres") "postgresql.service");

      serviceConfig = {
        ExecStart = "${pkgs.dex-oidc}/bin/dex serve /run/dex/config.yaml";
        ExecStartPre = [
          "${pkgs.coreutils}/bin/install -m 600 ${configFile} /run/dex/config.yaml"
          "+${startPreScript}"
        ];
        RuntimeDirectory = "dex";

        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        BindReadOnlyPaths = [
          "/nix/store"
          "-/etc/resolv.conf"
          "-/etc/nsswitch.conf"
          "-/etc/hosts"
          "-/etc/localtime"
          "-/etc/dex"
        ];
        BindPaths = optional (cfg.settings.storage.type == "postgres") "/var/run/postgresql";
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
        # ProtectClock= adds DeviceAllow=char-rtc r
        DeviceAllow = "";
        DynamicUser = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        # Port needs to be exposed to the host network
        #PrivateNetwork = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectHome = true;
        ProtectHostname = true;
        # Would re-mount paths ignored by temporary root
        #ProtectSystem = "strict";
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "~@privileged @resources @setuid @keyring" ];
        TemporaryFileSystem = "/:ro";
        # Does not work well with the temporary root
        #UMask = "0066";
      };
    };
  };
}
