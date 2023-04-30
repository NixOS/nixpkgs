{ config, pkgs, lib, ... }:

with lib;

let
  inherit (lib.options) showOption showFiles;

  cfg = config.services.dokuwiki;
  eachSite = cfg.sites;
  user = "dokuwiki";
  webserver = config.services.${cfg.webserver};

  mkPhpIni = generators.toKeyValue {
    mkKeyValue = generators.mkKeyValueDefault {} " = ";
  };
  mkPhpPackage = cfg: cfg.phpPackage.buildEnv {
    extraConfig = mkPhpIni cfg.phpOptions;
  };

  dokuwikiAclAuthConfig = hostName: cfg: let
    inherit (cfg) acl;
    acl_gen = concatMapStringsSep "\n" (l: "${l.page} \t ${l.actor} \t ${toString l.level}");
  in pkgs.writeText "acl.auth-${hostName}.php" ''
    # acl.auth.php
    # <?php exit()?>
    #
    # Access Control Lists
    #
    ${if isString acl then acl else acl_gen acl}
  '';

  mergeConfig = cfg: {
    useacl = false; # Dokuwiki default
    savedir = cfg.stateDir;
  } // cfg.settings;

  writePhpFile = name: text: pkgs.writeTextFile {
    inherit name;
    text = "<?php\n${text}";
    checkPhase = "${pkgs.php81}/bin/php --syntax-check $target";
  };

  mkPhpValue = v: let
    isHasAttr = s: isAttrs v && hasAttr s v;
  in
    if isString v then escapeShellArg v
    # NOTE: If any value contains a , (comma) this will not get escaped
    else if isList v && any lib.strings.isCoercibleToString v then escapeShellArg (concatMapStringsSep "," toString v)
    else if isInt v then toString v
    else if isBool v then toString (if v then 1 else 0)
    else if isHasAttr "_file" then "trim(file_get_contents(${lib.escapeShellArg v._file}))"
    else if isHasAttr "_raw" then v._raw
    else abort "The dokuwiki localConf value ${lib.generators.toPretty {} v} can not be encoded."
  ;

  mkPhpAttrVals = v: flatten (mapAttrsToList mkPhpKeyVal v);
  mkPhpKeyVal = k: v: let
    values = if (isAttrs v && (hasAttr "_file" v || hasAttr "_raw" v )) || !isAttrs v then
      [" = ${mkPhpValue v};"]
    else
      mkPhpAttrVals v;
  in map (e: "[${escapeShellArg k}]${e}") (flatten values);

  dokuwikiLocalConfig = hostName: cfg: let
    conf_gen = c: map (v: "$conf${v}") (mkPhpAttrVals c);
  in writePhpFile "local-${hostName}.php" ''
    ${concatStringsSep "\n" (conf_gen cfg.mergedConfig)}
  '';

  dokuwikiPluginsLocalConfig = hostName: cfg: let
    pc = cfg.pluginsConfig;
    pc_gen = pc: concatStringsSep "\n" (mapAttrsToList (n: v: "$plugins['${n}'] = ${boolToString v};") pc);
  in writePhpFile "plugins.local-${hostName}.php" ''
    ${if isString pc then pc else pc_gen pc}
  '';


  pkg = hostName: cfg: cfg.package.combine {
    inherit (cfg) plugins templates;

    pname = p: "${p.pname}-${hostName}";

    basePackage = cfg.package;
    localConfig = dokuwikiLocalConfig hostName cfg;
    pluginsConfig = dokuwikiPluginsLocalConfig hostName cfg;
    aclConfig = if cfg.settings.useacl && cfg.acl != null then dokuwikiAclAuthConfig hostName cfg else null;
  };

  aclOpts = { ... }: {
    options = {

      page = mkOption {
        type = types.str;
        description = lib.mdDoc "Page or namespace to restrict";
        example = "start";
      };

      actor = mkOption {
        type = types.str;
        description = lib.mdDoc "User or group to restrict";
        example = "@external";
      };

      level = let
        available = {
          "none" = 0;
          "read" = 1;
          "edit" = 2;
          "create" = 4;
          "upload" = 8;
          "delete" = 16;
        };
      in mkOption {
        type = types.enum ((attrValues available) ++ (attrNames available));
        apply = x: if isInt x then x else available.${x};
        description = lib.mdDoc ''
          Permission level to restrict the actor(s) to.
          See <https://www.dokuwiki.org/acl#background_info> for explanation
        '';
        example = "read";
      };
    };
  };

  # The current implementations of `doRename`,  `mkRenamedOptionModule` do not provide the full options path when used with submodules.
  # They would only show `settings.useacl' instead of `services.dokuwiki.sites."site1.local".settings.useacl'
  # The partial re-implementation of these functions is done to help users in debugging by showing the full path.
  mkRenamed = from: to: { config, options, name, ... }: let
    pathPrefix = [ "services" "dokuwiki" "sites" name ];
    fromPath = pathPrefix  ++ from;
    fromOpt = getAttrFromPath from options;
    toOp = getAttrsFromPath to config;
    toPath = pathPrefix ++ to;
  in {
    options = setAttrByPath from (mkOption {
      visible = false;
      description = lib.mdDoc "Alias of {option}${showOption toPath}";
      apply = x: builtins.trace "Obsolete option `${showOption fromPath}' is used. It was renamed to ${showOption toPath}" toOp;
    });
    config = mkMerge [
      {
        warnings = optional fromOpt.isDefined
          "The option `${showOption fromPath}' defined in ${showFiles fromOpt.files} has been renamed to `${showOption toPath}'.";
      }
      (lib.modules.mkAliasAndWrapDefsWithPriority (setAttrByPath to) fromOpt)
    ];
  };

  siteOpts = { options, config, lib, name, ... }:
    {
      imports = [
        (mkRenamed [ "aclUse" ] [ "settings" "useacl" ])
        (mkRenamed [ "superUser" ] [ "settings" "superuser" ])
        (mkRenamed [ "disableActions" ] [ "settings"  "disableactions" ])
        ({ config, options, ... }: let
          showPath = suffix: lib.options.showOption ([ "services" "dokuwiki" "sites" name ] ++ suffix);
          replaceExtraConfig = "Please use `${showPath ["settings"]}' to pass structured settings instead.";
          ecOpt = options.extraConfig;
          ecPath = showPath [ "extraConfig" ];
        in {
          options.extraConfig = mkOption {
            visible = false;
            apply = x: throw "The option ${ecPath} can no longer be used since it's been removed.\n${replaceExtraConfig}";
          };
          config.assertions = [
            {
              assertion = !ecOpt.isDefined;
              message = "The option definition `${ecPath}' in ${showFiles ecOpt.files} no longer has any effect; please remove it.\n${replaceExtraConfig}";
            }
            {
              assertion = config.mergedConfig.useacl -> (config.acl != null || config.aclFile != null);
              message = "Either ${showPath [ "acl" ]} or ${showPath [ "aclFile" ]} is mandatory if ${showPath [ "settings" "useacl" ]} is true";
            }
            {
              assertion = config.usersFile != null -> config.mergedConfig.useacl != false;
              message = "${showPath [ "settings" "useacl" ]} is required when ${showPath [ "usersFile" ]} is set (Currently defiend as `${config.usersFile}' in ${showFiles options.usersFile.files}).";
            }
          ];
        })
      ];

      options = {
        enable = mkEnableOption (lib.mdDoc "DokuWiki web application");

        package = mkOption {
          type = types.package;
          default = pkgs.dokuwiki;
          defaultText = literalExpression "pkgs.dokuwiki";
          description = lib.mdDoc "Which DokuWiki package to use.";
        };

        stateDir = mkOption {
          type = types.path;
          default = "/var/lib/dokuwiki/${name}/data";
          description = lib.mdDoc "Location of the DokuWiki state directory.";
        };

        acl = mkOption {
          type = with types; nullOr (listOf (submodule aclOpts));
          default = null;
          example = literalExpression ''
            [
              {
                page = "start";
                actor = "@external";
                level = "read";
              }
              {
                page = "*";
                actor = "@users";
                level = "upload";
              }
            ]
          '';
          description = lib.mdDoc ''
            Access Control Lists: see <https://www.dokuwiki.org/acl>
            Mutually exclusive with services.dokuwiki.aclFile
            Set this to a value other than null to take precedence over aclFile option.

            Warning: Consider using aclFile instead if you do not
            want to store the ACL in the world-readable Nix store.
          '';
        };

        aclFile = mkOption {
          type = with types; nullOr str;
          default = if (config.mergedConfig.useacl && config.acl == null) then "/var/lib/dokuwiki/${name}/acl.auth.php" else null;
          description = lib.mdDoc ''
            Location of the dokuwiki acl rules. Mutually exclusive with services.dokuwiki.acl
            Mutually exclusive with services.dokuwiki.acl which is preferred.
            Consult documentation <https://www.dokuwiki.org/acl> for further instructions.
            Example: <https://github.com/splitbrain/dokuwiki/blob/master/conf/acl.auth.php.dist>
          '';
          example = "/var/lib/dokuwiki/${name}/acl.auth.php";
        };

        pluginsConfig = mkOption {
          type = with types; attrsOf bool;
          default = {
            authad = false;
            authldap = false;
            authmysql = false;
            authpgsql = false;
          };
          description = lib.mdDoc ''
            List of the dokuwiki (un)loaded plugins.
          '';
        };

        usersFile = mkOption {
          type = with types; nullOr str;
          default = if config.mergedConfig.useacl then "/var/lib/dokuwiki/${name}/users.auth.php" else null;
          description = lib.mdDoc ''
            Location of the dokuwiki users file. List of users. Format:

                login:passwordhash:Real Name:email:groups,comma,separated

            Create passwordHash easily by using:

                mkpasswd -5 password `pwgen 8 1`

            Example: <https://github.com/splitbrain/dokuwiki/blob/master/conf/users.auth.php.dist>
            '';
          example = "/var/lib/dokuwiki/${name}/users.auth.php";
        };

        plugins = mkOption {
          type = types.listOf types.path;
          default = [];
          description = lib.mdDoc ''
                List of path(s) to respective plugin(s) which are copied from the 'plugin' directory.

                ::: {.note}
                These plugins need to be packaged before use, see example.
                :::
          '';
          example = literalExpression ''
                let
                  plugin-icalevents = pkgs.stdenv.mkDerivation rec {
                    name = "icalevents";
                    version = "2017-06-16";
                    src = pkgs.fetchzip {
                      stripRoot = false;
                      url = "https://github.com/real-or-random/dokuwiki-plugin-icalevents/releases/download/''${version}/dokuwiki-plugin-icalevents-''${version}.zip";
                      hash = "sha256-IPs4+qgEfe8AAWevbcCM9PnyI0uoyamtWeg4rEb+9Wc=";
                    };
                    installPhase = "mkdir -p $out; cp -R * $out/";
                  };
                # And then pass this theme to the plugin list like this:
                in [ plugin-icalevents ]
          '';
        };

        templates = mkOption {
          type = types.listOf types.path;
          default = [];
          description = lib.mdDoc ''
                List of path(s) to respective template(s) which are copied from the 'tpl' directory.

                ::: {.note}
                These templates need to be packaged before use, see example.
                :::
          '';
          example = literalExpression ''
                let
                  template-bootstrap3 = pkgs.stdenv.mkDerivation rec {
                  name = "bootstrap3";
                  version = "2022-07-27";
                  src = pkgs.fetchFromGitHub {
                    owner = "giterlizzi";
                    repo = "dokuwiki-template-bootstrap3";
                    rev = "v''${version}";
                    hash = "sha256-B3Yd4lxdwqfCnfmZdp+i/Mzwn/aEuZ0ovagDxuR6lxo=";
                  };
                  installPhase = "mkdir -p $out; cp -R * $out/";
                };
                # And then pass this theme to the template list like this:
                in [ template-bootstrap3 ]
          '';
        };

        poolConfig = mkOption {
          type = with types; attrsOf (oneOf [ str int bool ]);
          default = {
            "pm" = "dynamic";
            "pm.max_children" = 32;
            "pm.start_servers" = 2;
            "pm.min_spare_servers" = 2;
            "pm.max_spare_servers" = 4;
            "pm.max_requests" = 500;
          };
          description = lib.mdDoc ''
            Options for the DokuWiki PHP pool. See the documentation on `php-fpm.conf`
            for details on configuration directives.
          '';
        };

        phpPackage = mkOption {
          type = types.package;
          relatedPackages = [ "php80" "php81" ];
          default = pkgs.php81;
          defaultText = "pkgs.php81";
          description = lib.mdDoc ''
            PHP package to use for this dokuwiki site.
          '';
        };

        phpOptions = mkOption {
          type = types.attrsOf types.str;
          default = {};
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

        settings = mkOption {
          type = types.attrsOf types.anything;
          default = {
            useacl = true;
            superuser = "admin";
          };
          description = lib.mdDoc ''
            Structural DokuWiki configuration.
            Refer to <https://www.dokuwiki.org/config>
            for details and supported values.
            Settings can either be directly set from nix,
            loaded from a file using `._file` or obtained from any
            PHP function calls using `._raw`.
          '';
          example = literalExpression ''
            {
              title = "My Wiki";
              userewrite = 1;
              disableactions = [ "register" ]; # Will be concatenated with commas
              plugin.smtp = {
                smtp_pass._file = "/var/run/secrets/dokuwiki/smtp_pass";
                smtp_user._raw = "getenv('DOKUWIKI_SMTP_USER')";
              };
            }
          '';
        };

        mergedConfig = mkOption {
          readOnly = true;
          default = mergeConfig config;
          defaultText = literalExpression ''
            {
              useacl = true;
            }
          '';
          description = lib.mdDoc ''
            Read only representation of the final configuration.
          '';
        };

      # Required for the mkRenamedOptionModule
      # TODO: Remove me once https://github.com/NixOS/nixpkgs/issues/96006 is fixed
      # or we don't have any more notes about the removal of extraConfig, ...
      warnings = mkOption {
        type = types.listOf types.unspecified;
        default = [ ];
        visible = false;
        internal = true;
      };
      assertions = mkOption {
        type = types.listOf types.unspecified;
        default = [ ];
        visible = false;
        internal = true;
      };
    };
  };
in
{
  options = {
    services.dokuwiki = {

      sites = mkOption {
        type = types.attrsOf (types.submodule siteOpts);
        default = {};
        description = lib.mdDoc "Specification of one or more DokuWiki sites to serve";
      };

      webserver = mkOption {
        type = types.enum [ "nginx" "caddy" ];
        default = "nginx";
        description = lib.mdDoc ''
          Whether to use nginx or caddy for virtual host management.

          Further nginx configuration can be done by adapting `services.nginx.virtualHosts.<name>`.
          See [](#opt-services.nginx.virtualHosts) for further information.

          Further caddy configuration can be done by adapting `services.caddy.virtualHosts.<name>`.
          See [](#opt-services.caddy.virtualHosts) for further information.
        '';
      };

    };
  };

  # implementation
  config = mkIf (eachSite != {}) (mkMerge [{

    warnings = flatten (mapAttrsToList (_: cfg: cfg.warnings) eachSite);

    assertions = flatten (mapAttrsToList (_: cfg: cfg.assertions) eachSite);

    services.phpfpm.pools = mapAttrs' (hostName: cfg: (
      nameValuePair "dokuwiki-${hostName}" {
        inherit user;
        group = webserver.group;

        phpPackage = mkPhpPackage cfg;
        phpEnv = optionalAttrs (cfg.usersFile != null) {
          DOKUWIKI_USERS_AUTH_CONFIG = "${cfg.usersFile}";
        } // optionalAttrs (cfg.mergedConfig.useacl) {
          DOKUWIKI_ACL_AUTH_CONFIG = if (cfg.acl != null) then "${dokuwikiAclAuthConfig hostName cfg}" else "${toString cfg.aclFile}";
        };

        settings = {
          "listen.owner" = webserver.user;
          "listen.group" = webserver.group;
        } // cfg.poolConfig;
      }
    )) eachSite;

  }

  {
    systemd.tmpfiles.rules = flatten (mapAttrsToList (hostName: cfg: [
      "d ${cfg.stateDir}/attic 0750 ${user} ${webserver.group} - -"
      "d ${cfg.stateDir}/cache 0750 ${user} ${webserver.group} - -"
      "d ${cfg.stateDir}/index 0750 ${user} ${webserver.group} - -"
      "d ${cfg.stateDir}/locks 0750 ${user} ${webserver.group} - -"
      "d ${cfg.stateDir}/log 0750 ${user} ${webserver.group} - -"
      "d ${cfg.stateDir}/media 0750 ${user} ${webserver.group} - -"
      "d ${cfg.stateDir}/media_attic 0750 ${user} ${webserver.group} - -"
      "d ${cfg.stateDir}/media_meta 0750 ${user} ${webserver.group} - -"
      "d ${cfg.stateDir}/meta 0750 ${user} ${webserver.group} - -"
      "d ${cfg.stateDir}/pages 0750 ${user} ${webserver.group} - -"
      "d ${cfg.stateDir}/tmp 0750 ${user} ${webserver.group} - -"
    ] ++ lib.optional (cfg.aclFile != null) "C ${cfg.aclFile} 0640 ${user} ${webserver.group} - ${pkg hostName cfg}/share/dokuwiki/conf/acl.auth.php.dist"
    ++ lib.optional (cfg.usersFile != null) "C ${cfg.usersFile} 0640 ${user} ${webserver.group} - ${pkg hostName cfg}/share/dokuwiki/conf/users.auth.php.dist"
    ) eachSite);

    users.users.${user} = {
      group = webserver.group;
      isSystemUser = true;
    };
  }

  (mkIf (cfg.webserver == "nginx") {
    services.nginx = {
      enable = true;
      virtualHosts = mapAttrs (hostName: cfg: {
        serverName = mkDefault hostName;
        root = "${pkg hostName cfg}/share/dokuwiki";

        locations = {
          "~ /(conf/|bin/|inc/|install.php)" = {
            extraConfig = "deny all;";
          };

          "~ ^/data/" = {
            root = "${cfg.stateDir}";
            extraConfig = "internal;";
          };

          "~ ^/lib.*\.(js|css|gif|png|ico|jpg|jpeg)$" = {
            extraConfig = "expires 365d;";
          };

          "/" = {
            priority = 1;
            index = "doku.php";
            extraConfig = ''try_files $uri $uri/ @dokuwiki;'';
          };

          "@dokuwiki" = {
            extraConfig = ''
              # rewrites "doku.php/" out of the URLs if you set the userwrite setting to .htaccess in dokuwiki config page
              rewrite ^/_media/(.*) /lib/exe/fetch.php?media=$1 last;
              rewrite ^/_detail/(.*) /lib/exe/detail.php?media=$1 last;
              rewrite ^/_export/([^/]+)/(.*) /doku.php?do=export_$1&id=$2 last;
              rewrite ^/(.*) /doku.php?id=$1&$args last;
            '';
          };

          "~ \\.php$" = {
            extraConfig = ''
              try_files $uri $uri/ /doku.php;
              include ${config.services.nginx.package}/conf/fastcgi_params;
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
              fastcgi_param REDIRECT_STATUS 200;
              fastcgi_pass unix:${config.services.phpfpm.pools."dokuwiki-${hostName}".socket};
              '';
          };

        };
      }) eachSite;
    };
  })

  (mkIf (cfg.webserver == "caddy") {
    services.caddy = {
      enable = true;
      virtualHosts = mapAttrs' (hostName: cfg: (
        nameValuePair "http://${hostName}" {
          extraConfig = ''
            root * ${pkg hostName cfg}/share/dokuwiki
            file_server

            encode zstd gzip
            php_fastcgi unix/${config.services.phpfpm.pools."dokuwiki-${hostName}".socket}

            @restrict_files {
              path /data/* /conf/* /bin/* /inc/* /vendor/* /install.php
            }

            respond @restrict_files 404

            @allow_media {
              path_regexp path ^/_media/(.*)$
            }
            rewrite @allow_media /lib/exe/fetch.php?media=/{http.regexp.path.1}

            @allow_detail   {
              path /_detail*
            }
            rewrite @allow_detail /lib/exe/detail.php?media={path}

            @allow_export   {
              path /_export*
              path_regexp export /([^/]+)/(.*)
            }
            rewrite @allow_export /doku.php?do=export_{http.regexp.export.1}&id={http.regexp.export.2}

            try_files {path} {path}/ /doku.php?id={path}&{query}
          '';
        }
      )) eachSite;
    };
  })

  ]);

  meta.maintainers = with maintainers; [
    _1000101
    onny
    dandellion
    e1mo
  ];
}
