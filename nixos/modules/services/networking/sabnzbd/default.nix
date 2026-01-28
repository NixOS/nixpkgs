{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkOption
    mkPackageOption
    mkEnableOption
    mkOptionDefault
    mkIf
    literalExpression
    types
    ;
  inherit (lib.generators)
    mkKeyValueDefault
    mkValueStringDefault
    toKeyValue
    ;

  enumFromAttrs =
    enum_values:
    types.coercedTo (types.enum (lib.attrNames enum_values)) (name: enum_values.${name}) (
      types.enum (lib.attrValues enum_values)
    );

  cfg = config.services.sabnzbd;

  mandatoryGlobalSettings = {
    "__version__" = 19;
    "__encoding__" = "utf-8";
  };
  allSettings = cfg.settings // mandatoryGlobalSettings;

  # sabnzbd uses configobj type inis, which support
  # nested sections specified by increasing numbers
  # of square brackets (but not toml style dotted paths)
  configObjAtom = types.oneOf [
    types.str
    types.int
    types.bool
  ];

  configObjValue =
    let
      valueType =
        types.oneOf [
          types.str
          types.int
          types.bool
          (types.listOf configObjAtom)
          (types.attrsOf valueType)
        ]
        // {
          description = "ConfigObj type";
        };
    in
    valueType;

  configObjIni =
    { }:
    let
      extractAtoms = lib.filterAttrs (k: v: v != null && !lib.isAttrs v);
      extractSections = lib.filterAttrs (k: v: lib.isAttrs v);
      mkValueString = (
        v:
        if true == v then
          "1"
        else if false == v then
          "0"
        else
          mkValueStringDefault { } v
      );
      mkKeyValue = mkKeyValueDefault { inherit mkValueString; } "=";
      mkSection = (
        depth: attrs:
        let
          sections = extractSections attrs;
          sectionHeadingLeft = lib.concatStrings (lib.replicate (depth + 1) "[");
          sectionHeadingRight = lib.concatStrings (lib.replicate (depth + 1) "]");
          mkSectionHeading =
            name: "${sectionHeadingLeft}${lib.escape [ "[" "]" ] name}${sectionHeadingRight}";
          mkSubsection = name: attrs: (mkSectionHeading name) + "\n" + (mkSection (depth + 1) attrs) + "\n";
        in
        toKeyValue { inherit mkKeyValue; } (extractAtoms attrs)
        + "\n"
        + lib.concatStrings (lib.mapAttrsToList mkSubsection sections)
      );
    in
    {
      type = types.attrsOf configObjValue;
      generate = name: attrs: pkgs.writeText name (mkSection 0 attrs);
    };

  publicSettingsIni =
    if cfg.configFile != null then
      cfg.configFile
    else
      (configObjIni { }).generate "public-settings.ini" allSettings;

  sabnzbdIniPath =
    if cfg.configFile != null then cfg.configFile else "/var/lib/${cfg.stateDir}/sabnzbd.ini";
in

{
  options = {
    services.sabnzbd = {
      enable = mkEnableOption "the sabnzbd server";

      package = mkPackageOption pkgs "sabnzbd" { };

      configFile = mkOption {
        type = types.nullOr types.path;
        default =
          if lib.versionOlder config.system.stateVersion "26.05" then
            "/var/lib/sabnzbd/sabnzbd.ini"
          else
            null;
        description = "Path to config file (deprecated, use `settings` instead and set this value to null)";
      };

      stateDir = mkOption {
        type = types.str;
        default = "sabnzbd";
        description = "State directory of the service under /var/lib/";
      };

      user = mkOption {
        default = "sabnzbd";
        type = types.str;
        description = "User to run the service as";
      };

      group = mkOption {
        type = types.str;
        default = "sabnzbd";
        description = "Group to run the service as";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the sabnzbd web interface
        '';
      };

      secretFiles = mkOption {
        type = with types; listOf path;
        description = ''
          Path to a list of ini file containing confidential settings such as credentials.
          Settings here will be merged with the rest of the configuration (with
          the secret settings taking precedence in case of conflicts, and files
          that occur later in this list taking precedence over those that
          occur earlier).
          Recommended settings:
          - misc.api_key, misc.nzb_key, misc.username, misc.password
          - misc.email_account, misc.email_pwd if email alerts are enabled
          - servers.<name>.username, servers.<name>.password
        '';
        default = [ ];
      };

      allowConfigWrite = mkOption {
        type = types.bool;
        description = ''
          By default we create the sabnzbd configuration read-only,
          which keeps the nixos configuration as the single source
          of truth. If you want to enable configuration of
          sabnzbd via the web interface or use options that require
          a writeable configuration, such as quota tracking, enable
          this option.
        '';
        default = lib.versionOlder config.system.stateVersion "26.05";
      };

      settings = mkOption {
        description = ''
          The sabnzbd configuration (see also
          [sabnzbd's wiki](https://sabnzbd.org/wiki/configuration/4.5/configure)
          for extra documentation)
        '';
        default = { };
        type = types.submodule {
          freeformType = (configObjIni { }).type;
          config = {
            misc = {
              config_conversion_version = mkOptionDefault 4;
              # config_lock = 1 turns the alert that the config is read-only from an error
              # into a warning. But the warnings still come, and additionally read access
              # to the config from the web ui is blocked as well, so better keep it at 0
              # and live with the error
              # optionally, misc.helpful_warnings = 0 will silence the warnings (but not the error)
              # at the cost of also silencing other, potentially useful warnings
              # config_lock = mkOptionDefault (if !cfg.allowConfigWrite then 1 else 0);
              config_lock = mkOptionDefault false;
              notified_new_skin = mkOptionDefault true;
              # don't open the browser on a daemonized service
              auto_browser = mkOptionDefault false;
              # don't check for new updates since we're using the distro version
              check_new_rel = mkOptionDefault false;
            };
          };
          options = {
            misc = {
              bandwidth_max = mkOption {
                type = types.str;
                description = ''
                  Maximum bandwidth in bytes(!)/sec (supports prefixes). Use
                  in conjunction with `bandwidth_perc` to set a bandwidth
                  limit. Empty string disables limit.
                '';
                default = "";
                example = "50MB/s";
              };
              bandwidth_perc = mkOption {
                type = types.int;
                description = ''
                  Percentage of `bandwidth_max` that sabnzbd is allowed to use.
                  0 means no limit.
                '';
                default = 0;
                example = 50;
              };
              host = mkOption {
                type = types.str;
                description = ''
                  Address for the Web UI to listen on for incoming connections.
                '';
                default = "127.0.0.1";
                example = "0.0.0.0";
              };
              port = mkOption {
                type = types.port;
                description = ''
                  Port for the Web UI to listen on for incoming connections.
                '';
                default = 8080;
                example = 12345;
              };
              https_cert = mkOption {
                type = types.nullOr types.path;
                description = ''
                  Path to the TLS certificate for the web UI. If not set
                  and https is enabled, a self-signed certificate will
                  be generated.
                '';
                default = null;
                example = literalExpression "\${config.acme.certs.\${domain}.directory}/fullchain.pem";
              };
              https_key = mkOption {
                type = types.nullOr types.path;
                description = ''
                  Path to the TLS key for the web UI. If not set and
                  https is enabled, a self-signed certificate will be
                  generated
                '';
                default = null;
                example = literalExpression "\${config.acme.certs.\${domain}.directory}/key.pem";
              };
              enable_https = mkOption {
                type = types.bool;
                description = "Whether to enable HTTPS for the web UI";
                default = cfg.settings.misc.https_cert != null;
                defaultText = "cfg.settings.misc.https_cert != null";
                example = true;
              };
              cache_limit = mkOption {
                type = types.str;
                description = ''
                  Size of the RAM cache, in bytes (prefixes supported).
                  Sabnzbd recommends 25% of available RAM. Empty means
                  no cache.
                '';
                default = "";
                example = "500M";
              };
              html_login = mkOption {
                type = types.bool;
                description = ''
                  Prompt for login with an html login mask if enabled,
                  otherwise prompt for basic auth (useful for SSO)
                '';
                default = true;
              };
              inet_exposure = mkOption {
                type = enumFromAttrs {
                  "none" = 0;
                  "api (add nzbs)" = 1;
                  "api (no config)" = 2;
                  "api (full)" = 3;
                  "api+web (auth needed)" = 4;
                  "api+web (locally no auth)" = 5;
                };
                description = ''
                  Restrictions for access from non-local IP addresses.
                  Values are:
                  0, 'none'                      -- no access
                  1, 'api (add nzbs)'            -- api access only, only add nzb files
                  2, 'api (no config)'           -- api access only, config changes not allowed
                  3, 'api (full)'                -- api access only, full api access
                  4, 'api+web (auth needed)'     -- api and web ui, login required always
                  5, 'api+web (locally no auth)' -- api and web ui, login required from non-local IPs only
                '';
                default = "none";
              };
              email_endjob = mkOption {
                type = enumFromAttrs {
                  "never" = 0;
                  "always" = 1;
                  "on error" = 2;
                };
                description = ''
                  Whether to send emails on job completion. Values are:
                  0, 'never'    -- Never
                  1, 'always'   -- Always
                  2, 'on error' -- On error
                '';
                default = if cfg.settings.misc.email_server != "" then "on error" else "never";
                defaultText = ''if cfg.settings.misc.email_server != "" then "on error" else "never"'';
              };
              email_full = mkOption {
                type = types.bool;
                description = "Whether to send alerts for full disks";
                default = cfg.settings.misc.email_server != "";
                defaultText = ''cfg.settings.misc.email_server != ""'';
              };
              email_rss = mkOption {
                type = types.bool;
                description = "Whether to send alerts for jobs added by RSS feeds";
                default = false;
              };
              email_server = mkOption {
                type = types.str;
                description = "SMTP server for email alerts (server:host)";
                default = "";
              };
              email_to = mkOption {
                type = types.str;
                description = "Receiving address for email alerts";
                default = "";
              };
              email_from = mkOption {
                type = types.str;
                description = "'From:' field for emails (needs to be an address)";
                default = "";
              };
            };
            ntfosd = mkOption {
              default = { };
              description = "NotifyOSD settings";
              type = types.submodule {
                freeformType = (configObjIni { }).type;
                options = {
                  ntfosd_enable = mkOption {
                    type = types.bool;
                    description = ''
                      Whether to enable NotifyOSD alerts. Does not really make sense
                      in a server environment, hence we default to false despite
                      upstream's default true.
                    '';
                    default = false;
                  };
                };
              };
            };
            servers = mkOption {
              default = { };
              description = "Usenet provider specification";
              type = types.attrsOf (
                types.submodule {
                  freeformType = (configObjIni { }).type;
                  options = {
                    enable = mkOption {
                      type = types.bool;
                      description = "Enable this server by default";
                      default = true;
                      example = false;
                    };
                    required = mkOption {
                      type = types.bool;
                      description = ''
                        In case of connection failures, wait for the
                        server to come back online instead of skipping
                        it.
                      '';
                      default = false;
                      example = true;
                    };
                    optional = mkOption {
                      type = types.bool;
                      description = ''
                        In case of connection failures, temporarily
                        disable this server. (See sabnzbd's documentation
                        for usage guides).
                      '';
                      default = false;
                      example = true;
                    };
                    priority = mkOption {
                      type = types.int;
                      description = ''
                        Priority of this servers. Servers are queried in
                        order of priority, from highest (0) to lowest (100).
                      '';
                      default = 0;
                    };
                    name = mkOption {
                      type = types.str;
                      description = ''
                        The name of the server
                      '';
                      example = "Example News Provider";
                    };
                    displayname = mkOption {
                      type = types.str;
                      description = ''
                        Human-friendly description of the server
                      '';
                      example = "Example News Provider";
                    };
                    host = mkOption {
                      type = types.str;
                      description = ''
                        Hostname of the server
                      '';
                      example = "news.example.com";
                    };
                    port = mkOption {
                      type = types.port;
                      description = "Port of the server";
                      example = 443;
                      default = 563;
                    };
                    connections = mkOption {
                      type = types.int;
                      description = ''
                        Number of parallel connections permitted by
                        the server.
                      '';
                      example = 50;
                      default = 8;
                    };
                    timeout = mkOption {
                      type = types.int;
                      description = ''
                        Time, in seconds, to wait for a response before
                        attempting error recovery.
                      '';
                      default = 60;
                    };
                    ssl = mkOption {
                      type = types.bool;
                      description = ''
                        Whether the server supports TLS
                      '';
                      default = true;
                    };
                    ssl_verify = mkOption {
                      type = enumFromAttrs {
                        "strict" = 3;
                        "allow injection" = 2;
                        "none" = 0;
                      };
                      description = ''
                        Level of TLS verification. Supported values:
                        3, 'strict'          -- strict (normal) verification
                        2, 'allow injection' -- allow locally injected certificates
                        0, 'none'            -- no verification
                      '';
                      default = "strict";
                    };
                    expire_date = mkOption {
                      type = types.nullOr types.str;
                      description = ''
                        If Notifications are enabled and an expiry date is
                        set, warn 5 days before expiry. This setting
                        does not automatically disable the server.
                        Expected format: yyyy-mm-dd
                      '';
                      default = null;
                    };
                  };
                }
              );
            };
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    warnings = lib.optional (cfg.configFile != null) ''
      `sabnzbd.configFile` is deprecated, consider using `sabnzbd.settings` instead.
      If you have values set in `sabnzbd.settings` set, they will be ignored.
    '';

    users.users = mkIf (cfg.user == "sabnzbd") {
      sabnzbd = {
        isSystemUser = true;
        group = cfg.group;
        description = "sabnzbd user";
      };
    };

    users.groups = mkIf (cfg.group == "sabnzbd") {
      sabnzbd = { };
    };

    systemd.services.sabnzbd =
      let
        files =
          if cfg.configFile != null then
            [ sabnzbdIniPath ]
          else
            (lib.optional cfg.allowConfigWrite sabnzbdIniPath) ++ [ publicSettingsIni ] ++ cfg.secretFiles;
        iniPathQuoted = lib.escapeShellArg sabnzbdIniPath;
      in
      {
        description = "sabnzbd server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          Type = "forking";
          GuessMainPID = "no";
          User = cfg.user;
          Group = cfg.group;
          StateDirectory = cfg.stateDir;
          ExecStart = "${lib.getExe cfg.package} -d -f ${iniPathQuoted}";
        };
        preStart = ''
          set -euo pipefail

          ${lib.toShellVar "files" files}

          tmpfile=$(mktemp)

          ${lib.getExe (pkgs.python3.withPackages (py: [ py.configobj ]))} \
            ${./config_merge.py} \
            "''${files[@]}" \
            > "$tmpfile"

          install -D \
            -m ${if cfg.allowConfigWrite then "600" else "400"} \
            -o '${cfg.user}' -g '${cfg.group}' \
            "$tmpfile" \
            ${iniPathQuoted}

          rm "$tmpfile"
        '';
      };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.misc.port ];
    };
  };
}
