{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.librespeed;
in
{
  options.services.librespeed =
    let
      inherit (lib) mkOption types;
    in
    {
      enable = lib.mkEnableOption "LibreSpeed server";
      package = lib.mkPackageOption pkgs "librespeed-rust" { };
      domain = mkOption {
        description = ''
          If not `null`, this will add an entry to `services.librespeed.servers` and
          configure librespeed to use TLS.
        '';
        default = null;
        type = with types; nullOr nonEmptyStr;
      };
      downloadIPDB = mkOption {
        description = ''
          Whether to download the IP info database before starting librespeed.
          Disable this if you want to use the Go implementation.
        '';
        default = !(cfg.secrets ? "ipinfo_api_key");
        defaultText = lib.literalExpression ''!(cfg.secrets ? "ipinfo_api_key")'';
        type = types.bool;
      };
      openFirewall = mkOption {
        description = ''
          Whether to open the firewall for the specified port.
        '';
        default = false;
        type = types.bool;
      };
      secrets = mkOption {
        description = ''
          Attribute set of filesystem paths.
          The contents of the specified paths will be read at service start time and merged with the attributes provided in `settings`.
        '';
        default = { };
        type = with types; nullOr (attrsOf path);
      };
      settings = mkOption {
        description = ''
          LibreSpeed configuration written as Nix expression.
          All values set to `null` will be excluded from the evaluated config.
          This is useful if you want to omit certain defaults when using a different LibreSpeed implementation.

          See [github.com/librespeed][librespeed] for configuration help.

          [librespeed]: https://github.com/librespeed/speedtest-rust
        '';
        default = { };
        type =
          with types;
          nullOr (
            attrsOf (oneOf [
              (nullOr bool)
              int
              str
              package
            ])
          );
      };
      frontend = {
        enable = lib.mkEnableOption ''
          Enables the LibreSpeed frontend and adds a nginx virtual host if
          not explicetly disabled and `services.librespeed.domain` is not `null`.
        '';
        contactEmail = mkOption {
          description = "Email address listed in the privacy policy.";
          default =
            if (cfg.domain != null) then "webmaster@${cfg.domain}" else "webmaster@${config.networking.fqdn}";
          defaultText = lib.literalExpression ''
            if (config.services.librespeed.domain != null) then
              "webmaster@''${config.services.librespeed.domain}"
            else
              "webmaster@''${config.networking.fqdn}";
          '';
          type = types.str;
        };
        pageTitle = mkOption {
          description = "Title of the webpage.";
          default = "LibreSpeed";
          type = types.str;
        };
        useNginx = mkOption {
          description = ''
            Configure nginx for the LibreSpeed frontend.
            This will only create a virtual host for the frontend and won't proxy all requests because
            the reported upload and download speeds are inaccurate if proxied.
          '';
          default = cfg.domain != null;
          defaultText = lib.literalExpression "config.services.librespeed.domain != null";
          type = types.bool;
        };
        settings = mkOption {
          description = ''
            Override default settings of the speedtest web client.
            See [speedtest_worker.js][link] for a list of possible values.

            [link]: https://github.com/librespeed/speedtest/blob/master/speedtest_worker.js#L39
          '';
          default = {
            telemetry_level = "basic";
          };
          type =
            with types;
            nullOr (
              attrsOf (oneOf [
                bool
                int
                str
                float
              ])
            );
        };
        servers = mkOption {
          description = "LibreSpeed servers that should apper in the server list.";
          type = types.listOf (
            types.submodule {
              options =
                let
                  inherit (types) nonEmptyStr;
                in
                {
                  name = mkOption {
                    description = "Name shown in the server list.";
                    type = nonEmptyStr;
                  };
                  server = mkOption {
                    description = "URL to the server. You may use `//` instead of `http://` or `https://`.";
                    type = nonEmptyStr;
                  };
                  dlURL = mkOption {
                    description = ''
                      URL path to download test on this server.
                      Append `.php` to the default value if the server uses the php implementation.
                    '';
                    default = "backend/garbage";
                    type = nonEmptyStr;
                  };
                  ulURL = mkOption {
                    description = ''
                      URL path to upload test on this server.
                      Append `.php` to the default value if the server uses the php implementation.
                    '';
                    default = "backend/empty";
                    type = nonEmptyStr;
                  };
                  pingURL = mkOption {
                    description = ''
                      URL path to latency/jitter test on this server.
                      Append `.php` to the default value if the server uses the php implementation.
                    '';
                    default = "backend/empty";
                    type = nonEmptyStr;
                  };
                  getIpURL = mkOption {
                    description = ''
                      URL path to IP lookup on this server.
                      Append `.php` to the default value if the server uses the php implementation.
                    '';
                    default = "backend/getIP";
                    type = nonEmptyStr;
                  };
                };
            }
          );
        };
      };
    };
  config = lib.mkIf cfg.enable (
    let
      librespeedAssets =
        pkgs.runCommand "librespeed-assets"
          (
            let
              mapValue =
                arg:
                if (lib.isBool arg) then
                  lib.boolToString arg
                else if ((lib.isInt arg) || (lib.isFloat arg)) then
                  toString arg
                else
                  "\"${lib.escape [ "\"" ] (toString arg)}\"";

              mapSettings = lib.pipe cfg.frontend.settings [
                (lib.mapAttrs (name: val: "  s.setParameter(\"${lib.escape [ "\"" ] name}\",${mapValue val});"))
                (lib.attrValues)
                (lib.concatLines)
              ];
            in
            {
              preferLocal = true;

              serversList = ''
                function get_servers() {
                  return ${builtins.toJSON cfg.frontend.servers}
                }
                function override_settings () {
                ${mapSettings}
                }
              '';
            }
          )
          ''
            cp -r ${pkgs.librespeed-rust}/assets $out
            chmod 666 $out/servers_list.js
            cat >$out/servers_list.js <<<"$serversList"
            substitute ${pkgs.librespeed-rust}/assets/index.html $out/index.html \
              --replace-fail "s.setParameter(\"telemetry_level\",\"basic\"); //enable telemetry" "override_settings();" \
              --replace-fail "LibreSpeed Example" ${lib.escapeShellArg (lib.escapeXML cfg.frontend.pageTitle)} \
              --replace-fail "PUT@YOUR_EMAIL.HERE" ${lib.escapeShellArg (lib.escapeXML cfg.frontend.contactEmail)} \
              --replace-fail "TO BE FILLED BY DEVELOPER" ${lib.escapeShellArg (lib.escapeXML cfg.frontend.contactEmail)}
          '';
    in
    {
      assertions = [
        {
          assertion = cfg.frontend.useNginx -> cfg.domain != null;
          message = ''
            `services.librespeed.frontend.useNginx` requires `services.librespeed.frontend.domain` to be set.
          '';
        }
      ];

      networking.firewall = lib.mkIf cfg.openFirewall {
        allowedTCPPorts = [ cfg.settings.listen_port ];
      };
      services.nginx.virtualHosts = lib.mkIf (cfg.frontend.enable && cfg.frontend.useNginx) {
        ${cfg.domain} = {
          locations."/".root = librespeedAssets;
          locations."= /servers.json".return = "200 '${builtins.toJSON cfg.frontend.servers}'";
          locations."/backend/".return = "301 https://$host:${toString cfg.settings.listen_port}$request_uri";
          enableACME = true;
          forceSSL = true;
        };
      };
      security.acme.certs = lib.mkIf (cfg.domain != null) {
        ${cfg.domain} = {
          reloadServices = [ "librespeed.service" ];
          webroot = "/var/lib/acme/acme-challenge";
        };
      };

      services.librespeed.frontend.servers = lib.mkIf (cfg.frontend.enable && (cfg.domain != null)) [
        {
          name = cfg.domain;
          server = "//${cfg.domain}:${toString cfg.settings.listen_port}";
        }
      ];

      services.librespeed.settings =
        let
          inherit (lib) mkDefault mkIf;
        in
        {
          assets_path =
            if (cfg.frontend.enable && !cfg.frontend.useNginx) then
              librespeedAssets
            else
              pkgs.writeTextDir "index.html" "";

          bind_address = mkDefault "::";
          listen_port = mkDefault 8989;
          base_url = mkDefault "backend";
          worker_threads = mkDefault "auto";

          database_type = mkDefault "none";
          database_file = mkDefault "/var/lib/librespeed/speedtest.sqlite";

          #librespeed-rust will fail to start if the following config parameters are omitted.
          ipinfo_api_key = mkIf (!cfg.secrets ? "ipinfo_api_key") "";
          stats_password = mkIf (!cfg.secrets ? "stats_password") "";
          tls_cert_file =
            if (cfg.domain != null) then
              (mkDefault "/run/credentials/librespeed.service/cert.pem")
            else
              (mkDefault "");
          tls_key_file =
            if (cfg.domain != null) then
              (mkDefault "/run/credentials/librespeed.service/key.pem")
            else
              (mkDefault "");

          enable_tls = mkDefault (cfg.domain != null);
        };

      systemd.services =
        let
          configFile =
            let
              mapValue =
                arg:
                if (lib.isBool arg) then
                  lib.boolToString arg
                else if (lib.isInt arg) then
                  toString arg
                else
                  "\"${lib.escape [ "\"" ] (toString arg)}\"";
            in
            with lib;
            pipe cfg.settings [
              (filterAttrs (_: val: val != null))
              (mapAttrs (name: val: "${name}=${mapValue val}"))
              (attrValues)
              (concatLines)
              (pkgs.writeText "${cfg.package.name}-config.toml")
            ];
        in
        {
          librespeed-secrets = lib.mkIf (cfg.secrets != { }) {
            description = "LibreSpeed secret helper";

            ExecStart =
              let
                script = pkgs.writeShellApplication {
                  name = "librespeed-secrets";
                  runtimeInputs = [ pkgs.coreutils ];
                  text =
                    ''
                      cp ${configFile} ''${RUNTIME_DIRECTORY%%:*}/config.toml
                    ''
                    + lib.pipe cfg.secrets [
                      (lib.mapAttrs (
                        name: file: ''
                          cat >>''${RUNTIME_DIRECTORY%%:*}/config.toml <<EOF
                          ${name}="$(<${lib.escapeShellArg file})"
                          EOF
                        ''
                      ))
                      (lib.concatLines lib.attrValues)
                    ];
                };
              in
              lib.getExe script;

            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              RuntimeDirectory = "librespeed";
              UMask = "u=rw";
            };
          };
          librespeed = {
            description = "LibreSpeed server daemon";
            wantedBy = [ "multi-user.target" ];
            wants = [ "network-online.target" ];
            requires = lib.optionals (cfg.secrets != { }) [ "librespeed-secrets.service" ];

            serviceConfig = {
              Type = "simple";
              Restart = "always";

              DynamicUser = true;

              LoadCredential = lib.mkIf (cfg.domain != null) [
                "cert.pem:${config.security.acme.certs.${cfg.domain}.directory}/cert.pem"
                "key.pem:${config.security.acme.certs.${cfg.domain}.directory}/key.pem"
              ];

              ExecStartPre = lib.mkIf cfg.downloadIPDB "${lib.getExe cfg.package} --update-ipdb";
              ExecStart = "${lib.getExe cfg.package} -c ${
                if (cfg.secrets == { }) then configFile else "\${RUNTIME_DIRECTORY%%:*}/config.toml"
              }";
              WorkingDirectory = "/var/cache/librespeed";
              RuntimeDirectory = "librespeed";
              RuntimeDirectoryPreserve = true;
              StateDirectory = "librespeed";
              CacheDirectory = "librespeed";
              SyslogIdentifier = "librespeed";

              ReadOnlyPaths = [ cfg.package ];
              RestrictSUIDSGID = true;
              RestrictNamespaces = true;
              PrivateTmp = true;
              PrivateDevices = true;
              PrivateUsers = true;
              ProtectHostname = true;
              ProtectClock = true;
              ProtectKernelTunables = true;
              ProtectKernelModules = true;
              ProtectKernelLogs = true;
              ProtectControlGroups = true;
              ProtectSystem = "strict";
              ProtectHome = true;
              ProtectProc = "invisible";
              SystemCallArchitectures = "native";
              SystemCallFilter = "@system-service";
              SystemCallErrorNumber = "EPERM";
              LockPersonality = true;
              NoNewPrivileges = true;
            };
          };
        };
    }
  );

  meta.maintainers = with lib.maintainers; [ snaki ];
}
