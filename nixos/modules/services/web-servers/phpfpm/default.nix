{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.phpfpm;

  runtimeDir = "/run/phpfpm";

  toStr = value:
    if true == value then "yes"
    else if false == value then "no"
    else toString value;

  fpmCfgFile = pool: poolOpts: pkgs.writeText "phpfpm-${pool}.conf" ''
    [global]
    ${concatStringsSep "\n" (mapAttrsToList (n: v: "${n} = ${toStr v}") cfg.settings)}
    ${optionalString (cfg.extraConfig != null) cfg.extraConfig}

    [${pool}]
    ${concatStringsSep "\n" (mapAttrsToList (n: v: "${n} = ${toStr v}") poolOpts.settings)}
    ${concatStringsSep "\n" (mapAttrsToList (n: v: "env[${n}] = ${toStr v}") poolOpts.phpEnv)}
    ${optionalString (poolOpts.extraConfig != null) poolOpts.extraConfig}
  '';

  phpIni = poolOpts: pkgs.runCommand "php.ini" {
    inherit (poolOpts) phpPackage phpOptions;
    preferLocalBuild = true;
    passAsFile = [ "phpOptions" ];
  } ''
    cat ${poolOpts.phpPackage}/etc/php.ini $phpOptionsPath > $out
  '';

  poolOpts = { name, ... }:
    let
      poolOpts = cfg.pools.${name};
    in
    {
      options = {
        socket = mkOption {
          type = types.str;
          readOnly = true;
          description = ''
            Path to the unix socket file on which to accept FastCGI requests.

            ::: {.note}
            This option is read-only and managed by NixOS.
            :::
          '';
          example = "${runtimeDir}/<name>.sock";
        };

        listen = mkOption {
          type = types.str;
          default = "";
          example = "/path/to/unix/socket";
          description = ''
            The address on which to accept FastCGI requests.
          '';
        };

        phpPackage = mkOption {
          type = types.package;
          default = cfg.phpPackage;
          defaultText = literalExpression "config.services.phpfpm.phpPackage";
          description = ''
            The PHP package to use for running this PHP-FPM pool.
          '';
        };

        phpOptions = mkOption {
          type = types.lines;
          description = ''
            "Options appended to the PHP configuration file {file}`php.ini` used for this PHP-FPM pool."
          '';
        };

        phpEnv = lib.mkOption {
          type = with types; attrsOf str;
          default = {};
          description = ''
            Environment variables used for this PHP-FPM pool.
          '';
          example = literalExpression ''
            {
              HOSTNAME = "$HOSTNAME";
              TMP = "/tmp";
              TMPDIR = "/tmp";
              TEMP = "/tmp";
            }
          '';
        };

        user = mkOption {
          type = types.str;
          description = "User account under which this pool runs.";
        };

        group = mkOption {
          type = types.str;
          description = "Group account under which this pool runs.";
        };

        settings = mkOption {
          type = with types; attrsOf (oneOf [ str int bool ]);
          default = {};
          description = ''
            PHP-FPM pool directives. Refer to the "List of pool directives" section of
            <https://www.php.net/manual/en/install.fpm.configuration.php>
            for details. Note that settings names must be enclosed in quotes (e.g.
            `"pm.max_children"` instead of `pm.max_children`).
          '';
          example = literalExpression ''
            {
              "pm" = "dynamic";
              "pm.max_children" = 75;
              "pm.start_servers" = 10;
              "pm.min_spare_servers" = 5;
              "pm.max_spare_servers" = 20;
              "pm.max_requests" = 500;
            }
          '';
        };

        extraConfig = mkOption {
          type = with types; nullOr lines;
          default = null;
          description = ''
            Extra lines that go into the pool configuration.
            See the documentation on `php-fpm.conf` for
            details on configuration directives.
          '';
        };
      };

      config = {
        socket = if poolOpts.listen == "" then "${runtimeDir}/${name}.sock" else poolOpts.listen;
        group = mkDefault poolOpts.user;
        phpOptions = mkBefore cfg.phpOptions;

        settings = mapAttrs (name: mkDefault){
          listen = poolOpts.socket;
          user = poolOpts.user;
          group = poolOpts.group;
        };
      };
    };

in {
  imports = [
    (mkRemovedOptionModule [ "services" "phpfpm" "poolConfigs" ] "Use services.phpfpm.pools instead.")
    (mkRemovedOptionModule [ "services" "phpfpm" "phpIni" ] "")
  ];

  options = {
    services.phpfpm = {
      settings = mkOption {
        type = with types; attrsOf (oneOf [ str int bool ]);
        default = {};
        description = ''
          PHP-FPM global directives. Refer to the "List of global php-fpm.conf directives" section of
          <https://www.php.net/manual/en/install.fpm.configuration.php>
          for details. Note that settings names must be enclosed in quotes (e.g.
          `"pm.max_children"` instead of `pm.max_children`).
          You need not specify the options `error_log` or
          `daemonize` here, since they are generated by NixOS.
        '';
      };

      extraConfig = mkOption {
        type = with types; nullOr lines;
        default = null;
        description = ''
          Extra configuration that should be put in the global section of
          the PHP-FPM configuration file. Do not specify the options
          `error_log` or
          `daemonize` here, since they are generated by
          NixOS.
        '';
      };

      phpPackage = mkPackageOption pkgs "php" { };

      phpOptions = mkOption {
        type = types.lines;
        default = "";
        example =
          ''
            date.timezone = "CET"
          '';
        description = ''
          Options appended to the PHP configuration file {file}`php.ini`.
        '';
      };

      pools = mkOption {
        type = types.attrsOf (types.submodule poolOpts);
        default = {};
        example = literalExpression ''
         {
           mypool = {
             user = "php";
             group = "php";
             phpPackage = pkgs.php;
             settings = {
               "pm" = "dynamic";
               "pm.max_children" = 75;
               "pm.start_servers" = 10;
               "pm.min_spare_servers" = 5;
               "pm.max_spare_servers" = 20;
               "pm.max_requests" = 500;
             };
           }
         }'';
        description = ''
          PHP-FPM pools. If no pools are defined, the PHP-FPM
          service is disabled.
        '';
      };
    };
  };

  config = mkIf (cfg.pools != {}) {

    warnings =
      mapAttrsToList (pool: poolOpts: ''
        Using config.services.phpfpm.pools.${pool}.listen is deprecated and will become unsupported in a future release. Please reference the read-only option config.services.phpfpm.pools.${pool}.socket to access the path of your socket.
      '') (filterAttrs (pool: poolOpts: poolOpts.listen != "") cfg.pools) ++
      mapAttrsToList (pool: poolOpts: ''
        Using config.services.phpfpm.pools.${pool}.extraConfig is deprecated and will become unsupported in a future release. Please migrate your configuration to config.services.phpfpm.pools.${pool}.settings.
      '') (filterAttrs (pool: poolOpts: poolOpts.extraConfig != null) cfg.pools) ++
      optional (cfg.extraConfig != null) ''
        Using config.services.phpfpm.extraConfig is deprecated and will become unsupported in a future release. Please migrate your configuration to config.services.phpfpm.settings.
      ''
    ;

    services.phpfpm.settings = {
      error_log = "syslog";
      daemonize = false;
    };

    systemd.slices.system-phpfpm = {
      description = "PHP FastCGI Process manager pools slice";
    };

    systemd.targets.phpfpm = {
      description = "PHP FastCGI Process manager pools target";
      wantedBy = [ "multi-user.target" ];
    };

    systemd.services = mapAttrs' (pool: poolOpts:
      nameValuePair "phpfpm-${pool}" {
        description = "PHP FastCGI Process Manager service for pool ${pool}";
        after = [ "network.target" ];
        wantedBy = [ "phpfpm.target" ];
        partOf = [ "phpfpm.target" ];
        serviceConfig = let
          cfgFile = fpmCfgFile pool poolOpts;
          iniFile = phpIni poolOpts;
        in {
          Slice = "system-phpfpm.slice";
          PrivateDevices = true;
          PrivateTmp = true;
          ProtectSystem = "full";
          ProtectHome = true;
          # XXX: We need AF_NETLINK to make the sendmail SUID binary from postfix work
          RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";
          Type = "notify";
          ExecStart = "${poolOpts.phpPackage}/bin/php-fpm -y ${cfgFile} -c ${iniFile}";
          ExecReload = "${pkgs.coreutils}/bin/kill -USR2 $MAINPID";
          RuntimeDirectory = "phpfpm";
          RuntimeDirectoryPreserve = true; # Relevant when multiple processes are running
          Restart = "always";
        };
      }
    ) cfg.pools;
  };
}
