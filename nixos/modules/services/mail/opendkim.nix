{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.opendkim;

  defaultSock = "local:/run/opendkim/opendkim.sock";
  trustedHostsFile = pkgs.writeText "TrustedHosts" (lib.concatStringsSep "\n" cfg.trustedHosts);

  mergedSettings =
    (lib.optionalAttrs (cfg.trustedHosts != [ ]) {
      InternalHosts = "refile:/etc/opendkim/TrustedHosts";
      ExternalIgnoreList = "refile:/etc/opendkim/TrustedHosts";
    })
    // cfg.settings
    // lib.optionalAttrs (cfg.domainConfigs != { }) {
      KeyTable = "refile:${cfg.keyPath}/KeyTable";
      SigningTable = "refile:${cfg.keyPath}/SigningTable";
    };

  configFile = pkgs.writeText "opendkim.conf" (
    lib.concatStringsSep "\n" (lib.mapAttrsToList (name: value: "${name} ${value}") mergedSettings)
  );

  args =
    [
      "-f"
      "-l"
      "-p"
      cfg.socket
    ]
    ++ (
      if cfg.domainConfigs != { } then
        [
          "-x"
          configFile
        ]
      else
        [
          "-d"
          cfg.domains
          "-k"
          "${cfg.keyPath}/${cfg.selector}.private"
          "-s"
          cfg.selector
        ]
        ++ lib.optionals (cfg.configFile != null) [
          "-x"
          cfg.configFile
        ]
    );

in
{
  imports = [
    (lib.mkRenamedOptionModule [ "services" "opendkim" "keyFile" ] [ "services" "opendkim" "keyPath" ])
  ];

  options = {
    services.opendkim = {
      enable = lib.mkEnableOption "OpenDKIM sender authentication system";

      package = lib.mkPackageOption pkgs "opendkim" { };

      socket = lib.mkOption {
        type = lib.types.str;
        default = defaultSock;
        description = "Socket which is used for communication with OpenDKIM.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "opendkim";
        description = "User for the daemon.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "opendkim";
        description = "Group for the daemon.";
      };

      domains = lib.mkOption {
        type = lib.types.str;
        default = "csl:${config.networking.hostName}";
        defaultText = lib.literalExpression ''"csl:''${config.networking.hostName}"'';
        example = "csl:example.com,mydomain.net";
        description = ''
          Local domains set (see {manpage}`opendkim(8)` for more information on datasets).
          Messages from them are signed, not verified.
        '';
      };

      keyPath = lib.mkOption {
        type = lib.types.path;
        description = ''
          The path that opendkim should put its generated private keys into.
          The DNS settings will be found in this directory with the name selector.txt.
        '';
        default = "/var/lib/opendkim/keys";
      };

      selector = lib.mkOption {
        type = lib.types.str;
        description = "Selector to use when signing.";
      };

      # TODO: deprecate this?
      configFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Additional opendkim configuration as a file.";
      };

      settings = lib.mkOption {
        type =
          with lib.types;
          submodule {
            freeformType = attrsOf str;
          };
        default = { };
        description = "Additional opendkim configuration";
      };

      domainConfigs = lib.mkOption {
        type =
          with lib.types;
          attrsOf (submodule {
            options = {
              selector = lib.mkOption {
                type = lib.types.str;
                description = "Selector to use for this domain";
              };
            };
          });
        default = { };
        description = "Optional per-domain configurations for selectors";
      };

      trustedHosts = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        example = [
          "127.0.0.1"
          "::1"
          "localhost"
          "192.168.1.0/24"
          "*.example.com"
        ];
        description = ''
          List of hosts that are considered trusted and allowed to send emails.
          These hosts will be added to TrustedHosts file used by InternalHosts and ExternalIgnoreList.
        '';
      };

      keySize = lib.mkOption {
        type = lib.types.int;
        default = 2048;
        description = ''
          Key size in bits for RSA key generation.
          Common values are 1024, 2048, or 4096.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.domainConfigs != { } && cfg.configFile != null);
        message = "services.opendkim: Cannot use both 'domainConfigs' and 'configFile' options simultaneously. Please use either one or the other.";
      }
    ];

    users.users = lib.optionalAttrs (cfg.user == "opendkim") {
      opendkim = {
        group = cfg.group;
        uid = config.ids.uids.opendkim;
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == "opendkim") {
      opendkim.gid = config.ids.gids.opendkim;
    };

    environment = {
      etc = lib.mkMerge [
        (lib.mkIf (mergedSettings != { }) {
          "opendkim/opendkim.conf".source = configFile;
        })
        (lib.mkIf (cfg.trustedHosts != [ ]) {
          "opendkim/TrustedHosts".source = trustedHostsFile;
        })
      ];
      systemPackages = [
        lib.getExe
        cfg.package
      ];
    };

    services.opendkim.configFile = lib.mkIf (cfg.settings != { }) configFile;

    systemd.tmpfiles.rules = [
      "d '${cfg.keyPath}' - ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.opendkim = {
      description = "OpenDKIM signing and verification daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart =
        if cfg.domainConfigs != { } then
          ''
            cd "${cfg.keyPath}"
            ${lib.concatStringsSep "\n" (
              lib.mapAttrsToList (domain: conf: ''
                mkdir -p "${cfg.keyPath}/${domain}"
                if ! test -f ${domain}/${conf.selector}.private; then
                  ${lib.getExe cfg.package}-genkey -b ${toString cfg.keySize} -s ${conf.selector} -d ${domain} -D "${cfg.keyPath}/${domain}"
                  echo "Generated OpenDKIM key for ${domain}! Please update your DNS settings:\n"
                  cat ${domain}/${conf.selector}.txt
                fi
              '') cfg.domainConfigs
            )}

            cat > ${cfg.keyPath}/KeyTable <<EOF
            ${lib.concatStringsSep "\n" (
              lib.mapAttrsToList (
                domain: conf:
                "${conf.selector}._domainkey.${domain} ${domain}:${conf.selector}:${cfg.keyPath}/${domain}/${conf.selector}.private"
              ) cfg.domainConfigs
            )}
            EOF

            cat > ${cfg.keyPath}/SigningTable <<EOF
            ${lib.concatStringsSep "\n" (
              lib.mapAttrsToList (
                domain: conf: "*@${domain} ${conf.selector}._domainkey.${domain}"
              ) cfg.domainConfigs
            )}
            EOF
          ''
        else
          ''
            cd "${cfg.keyPath}"
            if ! test -f ${cfg.selector}.private; then
              ${lib.getExe cfg.package}-genkey -b ${toString cfg.keySize} -s ${cfg.selector} -d all-domains-generic-key
              echo "Generated OpenDKIM key! Please update your DNS settings:\n"
              cat ${cfg.selector}.txt
            fi
          '';

      serviceConfig = {
        ExecStart = "lib.getExe cfg.package ${lib.escapeShellArgs args}";
        User = cfg.user;
        Group = cfg.group;
        RuntimeDirectory = lib.optional (cfg.socket == defaultSock) "opendkim";
        StateDirectory = "opendkim";
        StateDirectoryMode = "0700";
        ReadWritePaths = [ cfg.keyPath ];

        AmbientCapabilities = [ ];
        CapabilityBoundingSet = "";
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6 AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged @resources"
        ];
        UMask = "0077";
      };
    };
  };
}
