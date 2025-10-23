{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.services.librespeed;
  opt = options.services.librespeed;

  settingsFormat = pkgs.formats.toml { };

  configFile = settingsFormat.generate "librespeed-rust-config.toml" cfg.settings;

  librespeedAssets =
    pkgs.runCommand "librespeed-assets"
      {
        serversList = ''
          function get_servers() {
            return ${builtins.toJSON cfg.frontend.servers}
          }
          function override_settings () {
          ${lib.pipe cfg.frontend.settings [
            (lib.mapAttrs (name: val: "  s.setParameter(${builtins.toJSON name},${builtins.toJSON val});"))
            lib.attrValues
            lib.concatLines
          ]}
          }
        '';
        passAsFile = [ "serversList" ];
      }
      ''
        cp -r ${cfg.package}/assets $out
        chmod +w "$out/servers_list.js"
        cp "$serversListPath" "$out/servers_list.js"
        substitute ${cfg.package}/assets/index.html $out/index.html \
          --replace-fail "s.setParameter(\"telemetry_level\",\"basic\"); //enable telemetry" "override_settings();" \
          --replace-fail "LibreSpeed Example" ${lib.escapeShellArg (lib.escapeXML cfg.frontend.pageTitle)} \
          --replace-fail "PUT@YOUR_EMAIL.HERE" ${lib.escapeShellArg (lib.escapeXML cfg.frontend.contactEmail)} \
          --replace-fail "TO BE FILLED BY DEVELOPER" ${lib.escapeShellArg (lib.escapeXML cfg.frontend.contactEmail)}
      '';
in
{
  options.services.librespeed = {
    enable = lib.mkEnableOption "LibreSpeed server";
    package = lib.mkPackageOption pkgs "librespeed-rust" { };

    domain = lib.mkOption {
      description = ''
        If not `null`, this will add an entry to `services.librespeed.servers` and
        configure librespeed to use TLS.
      '';
      default = null;
      type = with lib.types; nullOr nonEmptyStr;
    };

    downloadIPDB = lib.mkOption {
      description = ''
        Whether to download the IP info database before starting librespeed.
        Disable this if you want to use the Go implementation.
      '';
      default = !(cfg.secrets ? "ipinfo_api_key");
      defaultText = lib.literalExpression ''!(config.${opt.secrets} ? "ipinfo_api_key")'';
      type = lib.types.bool;
    };

    secrets = lib.mkOption {
      description = ''
        Attribute set of filesystem paths.
        The contents of the specified paths will be read at service start time and merged with the attributes provided in `settings`.
      '';
      default = { };
      type =
        with lib.types;
        nullOr (
          attrsOf (pathWith {
            inStore = false;
            absolute = true;
          })
        );
    };

    settings = lib.mkOption {
      description = ''
        LibreSpeed configuration written as Nix expression.
        All values set to `null` will be excluded from the evaluated config.
        This is useful if you want to omit certain defaults when using a different LibreSpeed implementation.

        See [github.com/librespeed](https://github.com/librespeed/speedtest-rust) for configuration help.
      '';
      default = {
        assets_path =
          if (cfg.frontend.enable && !cfg.frontend.useNginx) then
            librespeedAssets
          else
            pkgs.writeTextDir "index.html" "";

        bind_address = "::";
        listen_port = 8989;
        base_url = "backend";
        worker_threads = "auto";

        database_type = "none";
        database_file = "/var/lib/librespeed/speedtest.sqlite";

        # librespeed-rust will fail to start if the following config parameters are omitted.
        ipinfo_api_key = "";
        stats_password = "";

        redact_ip_addresses = false;
        result_image_theme = "light";

        enable_tls = cfg.tlsCertificate != null && cfg.tlsKey != null;
        tls_cert_file = lib.optionalString (
          cfg.tlsCertificate != null
        ) "/run/credentials/librespeed.service/cert.pem";
        tls_key_file = lib.optionalString (
          cfg.tlsKey != null
        ) "/run/credentials/librespeed.service/key.pem";
      };
      defaultText = lib.literalExpression ''
        {
          assets_path = if (config.${opt.frontend.enable} && !config.${opt.frontend.useNginx}) then
            librespeedAssets
          else
            pkgs.writeTextDir "index.html" "";

          bind_address = "::";
          listen_port = 8989;
          base_url = "backend";
          worker_threads = "auto";

          database_type = "none";
          database_file = "/var/lib/librespeed/speedtest.sqlite";

          # librespeed-rust will fail to start if the following config parameters are omitted.
          ipinfo_api_key = "";
          stats_password = "";

          redact_ip_addresses = false;
          result_image_theme = "light";

          enable_tls = config.${opt.tlsCertificate} != null && config.${opt.tlsKey} != null;
          tls_cert_file = lib.optionalString (config.${opt.tlsCertificate} != null) "/run/credentials/librespeed.service/cert.pem";
          tls_key_file = lib.optionalString (config.${opt.tlsKey} != null) "/run/credentials/librespeed.service/key.pem";
        }
      '';
      type =
        with lib.types;
        nullOr (
          attrsOf (oneOf [
            (nullOr bool)
            int
            str
            package
          ])
        );
    };

    useACMEHost = lib.mkOption {
      type = with lib.types; nullOr nonEmptyStr;
      default = null;
      example = "speed.example.com";
      description = ''
        Use a certificate generated by the NixOS ACME module for the given host.
        Note that this will not generate a new certificate - you will need to do so with `security.acme.certs`.
      '';
    };

    tlsCertificate = lib.mkOption {
      type = with lib.types; nullOr nonEmptyStr;
      default =
        if (cfg.useACMEHost != null) then
          "${config.security.acme.certs.${cfg.useACMEHost}.directory}/cert.pem"
        else
          null;
      defaultText = lib.literalExpression "lib.optionalString (config.${opt.useACMEHost} != null) \"\${config.security.acme.certs.\${config.${opt.useACMEHost}}.directory}/cert.pem\"";
      description = "TLS certificate to use. Use together with `tlsKey`.";
    };

    tlsKey = lib.mkOption {
      type = with lib.types; nullOr nonEmptyStr;
      default =
        if (cfg.useACMEHost != null) then
          "${config.security.acme.certs.${cfg.useACMEHost}.directory}/key.pem"
        else
          null;
      defaultText = lib.literalExpression "lib.optionalString (config.${opt.useACMEHost} != null) \"\${config.security.acme.certs.\${config.${opt.useACMEHost}}.directory}/key.pem\"";
      description = "TLS private key to use. Use together with `tlsCertificate`.";
    };

    frontend = {
      enable = lib.mkEnableOption "" // {
        description = ''
          Enables the LibreSpeed frontend and adds a nginx virtual host if
          not explicitly disabled and `services.librespeed.domain` is not `null`.
        '';
      };

      contactEmail = lib.mkOption {
        description = "Email address listed in the privacy policy.";
        type = lib.types.str;
      };

      pageTitle = lib.mkOption {
        description = "Title of the webpage.";
        default = "LibreSpeed";
        type = lib.types.str;
      };

      useNginx = lib.mkOption {
        description = ''
          Configure nginx for the LibreSpeed frontend.
          This will only create a virtual host for the frontend and won't proxy all requests because
          the reported upload and download speeds are inaccurate if proxied.
        '';
        default = cfg.domain != null;
        defaultText = lib.literalExpression "config.${opt.domain} != null";
        type = lib.types.bool;
      };

      settings = lib.mkOption {
        description = ''
          Override default settings of the speedtest web client.
          See [speedtest_worker.js][link] for a list of possible values.

          [link]: https://github.com/librespeed/speedtest/blob/master/speedtest_worker.js#L39
        '';
        default = {
          telemetry_level = "basic";
        };
        type = lib.types.nullOr (
          lib.types.submodule {
            freeformType =
              with lib.types;
              attrsOf (oneOf [
                bool
                int
                str
                float
              ]);
          }
        );
      };

      servers = lib.mkOption {
        description = "LibreSpeed servers that should appear in the server list.";
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              name = lib.mkOption {
                description = "Name shown in the server list.";
                type = lib.types.nonEmptyStr;
              };

              server = lib.mkOption {
                description = "URL to the server. You may use `//` instead of `http://` or `https://`.";
                type = lib.types.nonEmptyStr;
              };

              dlURL = lib.mkOption {
                description = ''
                  URL path to download test on this server.
                  Append `.php` to the default value if the server uses the php implementation.
                '';
                default = "backend/garbage";
                type = lib.types.nonEmptyStr;
              };

              ulURL = lib.mkOption {
                description = ''
                  URL path to upload test on this server.
                  Append `.php` to the default value if the server uses the php implementation.
                '';
                default = "backend/empty";
                type = lib.types.nonEmptyStr;
              };

              pingURL = lib.mkOption {
                description = ''
                  URL path to latency/jitter test on this server.
                  Append `.php` to the default value if the server uses the php implementation.
                '';
                default = "backend/empty";
                type = lib.types.nonEmptyStr;
              };

              getIpURL = lib.mkOption {
                description = ''
                  URL path to IP lookup on this server.
                  Append `.php` to the default value if the server uses the php implementation.
                '';
                default = "backend/getIP";
                type = lib.types.nonEmptyStr;
              };
            };
          }
        );
      };
    };
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.frontend.useNginx -> cfg.domain != null;
        message = "${opt.frontend.useNginx} requires ${opt.domain} to be set.";
      }
    ];

    security.acme.certs = lib.mkIf (cfg.useACMEHost != null) {
      ${cfg.useACMEHost}.reloadServices = [ "librespeed.service" ];
    };

    services = {
      librespeed = {
        frontend.servers = lib.mkIf (cfg.frontend.enable && (cfg.domain != null)) [
          {
            name = cfg.domain;
            server = "//${cfg.domain}";
          }
        ];
        settings = lib.mapAttrs (n: v: lib.mkDefault v) opt.settings.default;
      };

      nginx.virtualHosts = lib.mkIf (cfg.frontend.enable && cfg.frontend.useNginx) {
        ${cfg.domain} = {
          forceSSL = true;
          locations = {
            "/".root = librespeedAssets;
            "= /servers.json".return = "200 '${builtins.toJSON cfg.frontend.servers}'";
            "/backend/" = {
              proxyPass = "http://127.0.0.1:${toString cfg.settings.listen_port}/backend/";
              extraConfig = # nginx
              ''
                client_max_body_size 0;
                gzip off;
                proxy_buffering off;
                proxy_request_buffering off;
              ''
              + lib.optionalString (lib.any (m: m.name == "brotli") config.services.nginx.additionalModules) ''
                brotli off;
              ''
              + lib.optionalString (lib.any (m: m.name == "zstd") config.services.nginx.additionalModules) ''
                zstd off;
              '';
            };
          };
        };
      };
    };

    systemd.services = {
      librespeed-secrets = lib.mkIf (cfg.secrets != { }) {
        description = "LibreSpeed secret helper";

        ExecStart = lib.getExe (
          pkgs.writeShellApplication {
            name = "librespeed-secrets";
            runtimeInputs = [ pkgs.coreutils ];
            text = ''
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
          }
        );

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
        wants = [
          "network.target"
        ]
        ++ lib.optionals (cfg.useACMEHost != null) [
          "acme-finished-${cfg.useACMEHost}.target"
        ];
        requires = lib.optionals (cfg.secrets != { }) [ "librespeed-secrets.service" ];
        after = [
          "network.target"
        ]
        ++ lib.optionals (cfg.secrets != { }) [
          "librespeed-secrets.service"
        ]
        ++ lib.optionals (cfg.useACMEHost != null) [
          "acme-finished-${cfg.useACMEHost}.target"
        ];

        serviceConfig = {
          Type = "simple";
          Restart = "always";

          DynamicUser = true;

          LoadCredential = lib.mkIf (cfg.tlsCertificate != null && cfg.tlsKey != null) [
            "cert.pem:${cfg.tlsCertificate}"
            "key.pem:${cfg.tlsKey}"
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
  };

  meta.maintainers = lib.teams.c3d2.members;
}
