{ lib
, pkgs
, config
, ...
}:
with lib;

let
  user = "privatebin";
  group = user;
  cfg = config.services.privatebin;
  envVar = mkOptionType {
    name = "environment variable";
    description = "attribute set with _env as string";
    descriptionClass = "composite";
    check = x: isAttrs x && x ? _env && types.nonEmptyStr.check x._env;
  };
  isEnv = v: isAttrs v && v ? _env && isString v._env;
  format =
    let
      iniAtom = (pkgs.formats.ini {}).type/*attrsOf*/.functor.wrapped/*attrsOf*/.functor.wrapped;
    in
    pkgs.formats.ini { } // {
      type = with types; attrsOf (attrsOf (either iniAtom envVar));
    };

  expire_options = finalCfg.expire_options or {};
  expire_lines = let
    toList = mapAttrsToList (key: value: { inherit key value; });
    sortExpire = builtins.sort (a: b: (a.value < b.value) && a.value != 0);
  in
    map (v: "${v.key}=${toString v.value}") (sortExpire (toList expire_options));

  toIni = generators.toINI {
    mkKeyValue = flip generators.mkKeyValueDefault "=" rec {
      mkValueString = v:
        if isString v then ''"${toString v}"''
        else if isEnv v then "\${${v._env}}"
        else generators.mkValueStringDefault { } v;
    };
  };

  configFile = pkgs.writeTextDir "conf.php" ''
    ;<?php http_response_code(403); /*
    ${toIni (builtins.removeAttrs finalCfg ["expire_options"])}
    ${optionalString (expire_options != {}) ''
    [expire_options]
    ${concatStringsSep "\n" expire_lines}
    ''}
    ;*/
  '';

  autoDb = if !cfg.databaseSetup.enable then null else cfg.databaseSetup.kind;
  db_config = optionalAttrs (autoDb != null) (
    if autoDb == "mysql" then {
      model.class = "Database";
      model_options = {
        dsn = "mysql:unix_socket=/run/mysqld/mysqld.sock;dbname=${user}";
        usr = user;
      };
    } else if autoDb == "pgsql" then {
      model.class = "Database";
      model_options.dsn = "pgsql:host=/run/postgresql;port=${toString config.services.postgresql.port};dbname=${user}";
    } else if autoDb == "sqlite" then {
      model.class = "Database";
      model_options.dsn = "sqlite:/var/lib/privatebin/data/db.sqlite3";
    } else {}
  );
  finalCfg = recursiveUpdate cfg.settings db_config;
in
{
  meta.maintainers = with lib.maintainers; [ e1mo ];

  options.services.privatebin = {
    enable = mkEnableOption (mdDoc "PrivateBin web application");

    package = mkPackageOptionMD pkgs "privatebin" { };

    settings = mkOption {
      inherit (format) type;
      default = {};
      example = lib.literalExpression ''
        {
          main = {
            name._env = "PRIVATEBIN_NAME";
            basepath = "https://privatebin.example.com/";
            fileupload = true;
            syntaxhighlightingtheme = "sons-of-obsidian";
            info = "This instance of PrivateBin is hosted on NixOS!";
            languageselection = true;
            icon = "none";
            cspheader = "default-src 'none'; base-uri 'self'; form-action 'none'; manifest-src 'self'; connect-src * blob:; script-src 'self' 'unsafe-eval'; style-src 'self'; font-src 'self'; frame-ancestors 'none'; img-src 'self' data: blob:; media-src blob:; object-src blob:; sandbox allow-same-origin allow-scripts allow-forms allow-popups allow-modals allow-downloads";
            httpwarning = true;
          };
          expire.default = "1day";
          traffic = {
            limit = 10;
            exempted = "1.2.3.4,10.10.10/24";
          };
          purge = {
            limit = 300;
            batchsize = 10;
          };
          model = {
            class = "Database";
          };
          model_options = {
            dsn = "pgsql:host=localhost;dbname=privatebin";
            tbl = "privatebin_";
            user = "privatebin";
            pwd._env = "PRIVATEBIN_DB_PASS";
          };
        }
      '';
      description = lib.mdDoc ''
        Privatebin configuration as outlined in
        <https://github.com/PrivateBin/PrivateBin/wiki/Configuration>.

        Available sections are `[main]`, `[expire]`, `[expire_options]`,
        `[formatter_options]`, `[traffic]`, `[purge]`, `[model]`,
        `[model_options]` and `[yourls]`.
      '';
    };

    environmentFiles = mkOption {
      type = with types; listOf path;
      description = lib.mdDoc "Optional files containing environment variables with secrets to be passed to the config";
      default = [];
    };

    databaseSetup = {
      enable = mkEnableOption (lib.mdDoc "Automatic database setup and configuration");
      kind = mkOption {
        type = types.enum [ "pgsql" "mysql" "sqlite" ];
        description = lib.mdDoc "Type of database to automatically set up";
      };
    };

    poolConfig = mkOption {
      type = with types; attrsOf (oneOf [ str int bool ]);
      default = {
        "pm" = "ondemand";
        "pm.max_children" = 10;
        "pm.process_idle_timeout" = "30s";
        "pm.max_requests" = 200;
      };
      description = lib.mdDoc ''
        Options for the PrivateBin PHP pool. See the documentation on `php-fpm.conf`
        for details on configuration directives.
      '';
    };

    phpPackage = mkOption {
      type = types.package;
      relatedPackages = [ "php80" "php81" "php82" ];
      default = pkgs.php81;
      defaultText = "pkgs.php81";
      description = lib.mdDoc ''
        PHP package to use for this PrivateBin instance.
      '';
    };

    phpOptions = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = lib.mdDoc ''
        Options for PHP's php.ini file for this dokuwiki site.
      '';
      example = literalExpression ''
        {
          "opcache.interned_strings_buffer" = "8";
          "opcache.max_accelerated_files" = "10000";
          "opcache.memory_consumption" = "128";
          "opcache.revalidate_freq" = "15";
          "opcache.fast_shutdown" = "1";
        }
      '';
    };

    nginx = mkOption {
      type = types.submodule (import ../web-servers/nginx/vhost-options.nix { inherit config lib; });
      default = {};
      example = literalExpression ''
        {
          forceSSL = true;
          enableACME = true;
        }
      '';
      description = lib.mdDoc ''
        Optional settings to pass to the nginx virtualHost.
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users.${user} = {
      inherit group;

      isSystemUser = true;
      createHome = false;
    };
    users.users.${config.services.nginx.user} = mkIf config.services.nginx.enable { extraGroups = [ group ]; };
    users.groups.${group} = { };

    services.phpfpm.pools.${user} = {
      inherit user group;
      settings = {
        "listen.mode" = "0660";
        "listen.owner" = user;
        "listen.group" = group;
        "catch_workers_output" = true;
        "clear_env" = false;
      } // cfg.poolConfig;
      phpEnv.CONFIG_PATH = "${configFile}";
    };

    services.postgresql = mkIf (autoDb == "pgsql") {
      enable = true;
      ensureUsers = [{
        name = user;
        ensurePermissions = {
          "DATABASE \"${user}\"" = "ALL PRIVILEGES";
        };
      }];
      ensureDatabases = [
        user
      ];
    };

    services.mysql = mkIf (autoDb == "mysql") {
      enable = true;
      package = mkDefault pkgs.mariadb;
      ensureUsers = [{
        name = user;
        ensurePermissions = {
          "${user}.*" = "ALL PRIVILEGES";
        };
      }];
      ensureDatabases = [
        user
      ];
    };
    systemd.services."phpfpm-${user}".serviceConfig = {
      ProtectSystem = "full";
      PrivateTmp = true;
      EnvironmentFile = cfg.environmentFiles;
    };
    systemd.tmpfiles.rules = flatten [
      "d /var/lib/privatebin/data 0750 ${user} ${group} - -"
    ];

    services.nginx = {
      enable = mkDefault true;
      virtualHosts.privatebin = mkMerge [
        cfg.nginx
        {
          root = mkForce "${pkgs.privatebin}/share/privatebin";
          extraConfig = optionalString (cfg.nginx.addSSL || cfg.nginx.forceSSL || cfg.nginx.onlySSL || cfg.nginx.enableACME) "fastcgi_param HTTPS on;";
          locations = {
            "/" = {
              index = "index.php";
            };
            "~ \.php$" = {
              extraConfig = ''
                try_files $uri $uri/ /index.php?$query_string;
                include ${pkgs.nginx}/conf/fastcgi_params;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                fastcgi_param REDIRECT_STATUS 200;
                fastcgi_pass unix:${config.services.phpfpm.pools.${user}.socket};
                ${optionalString (cfg.nginx.addSSL || cfg.nginx.forceSSL || cfg.nginx.onlySSL || cfg.nginx.enableACME) "fastcgi_param HTTPS on;"}
              '';
            };
          };
        }
      ];
    };
  };
}
