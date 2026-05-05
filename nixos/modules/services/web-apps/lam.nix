{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.lam;
  php = cfg.package.php;

  hashPasswordPhp = pkgs.writeText "lam-hash-password.php" ''
    <?php
    $salt = bin2hex(random_bytes(16));
    $password = trim(file_get_contents($argv[1]));
    echo "{CRYPT-SHA512}" . crypt($password, '$6$' . $salt) . " " . base64_encode($salt);
  '';

  configCfgJson = builtins.toJSON ({ default = "lam"; } // cfg.settings);

  profileJsons = lib.mapAttrs (_name: builtins.toJSON) cfg.profiles;

  accountProfileDir = pkgs.linkFarm "lam-account-profiles" (
    lib.mapAttrsToList (name: attrs: {
      inherit name;
      path = pkgs.writeText "lam-profile-${name}" (
        lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "${k}: ${v}") attrs)
      );
    }) cfg.accountProfiles
  );

  seedConfigs =
    if cfg.masterPasswordFile != null then
      ''
        HASH=$(${php}/bin/php ${hashPasswordPhp} ${cfg.masterPasswordFile})

        echo ${lib.escapeShellArg configCfgJson} | \
          ${php}/bin/php -r 'echo json_encode(array_merge(json_decode(stream_get_contents(STDIN), true), ["password" => $argv[1]]), JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);' "$HASH" \
          > "$configDir/config.cfg"

        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (name: json: ''
            echo ${lib.escapeShellArg json} | \
              ${php}/bin/php -r 'echo json_encode(array_merge(json_decode(stream_get_contents(STDIN), true), ["Passwd" => $argv[1]]), JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);' "$HASH" \
              > "$configDir/${name}.conf"
          '') profileJsons
        )}
      ''
    else
      ''
        if [ ! -f "$configDir/config.cfg" ]; then
          cp "${cfg.package}/share/lam/config/config.cfg.sample" "$configDir/config.cfg"
        fi
        if [ ! -f "$configDir/lam.conf" ]; then
          for f in "${cfg.package}/share/lam/config/"*.sample.conf; do
            cp "$f" "$configDir/$(basename "$f" .sample.conf).conf"
          done
        fi
      '';
in
{
  options = {
    services.lam = {
      enable = lib.mkEnableOption "LDAP Account Manager (LAM)";

      package = lib.mkPackageOption pkgs "lam" { };

      virtualHost = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "lam";
        description = ''
          Name of the nginx virtualhost to use and setup.
          If null, do not setup any virtualhost.
        '';
      };

      openFirewall = lib.mkEnableOption "opening HTTP/HTTPS ports in the firewall";

      stateDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/lam";
        description = ''
          Directory for writable LAM state (config, sessions, tmp).
        '';
      };

      masterPasswordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Path to a file containing the master configuration password.
          When set, server profiles and global settings are managed
          declaratively and rewritten on every service start.
        '';
      };

      settings = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        default = { };
        description = "Freeform config.cfg settings.";
      };

      profiles = lib.mkOption {
        type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
        default = { };
        example = lib.literalExpression ''
          {
            lam = {
              ServerURL = "ldap://localhost:389";
              Admins = "cn=admin,dc=example,dc=com";
            };
          }
        '';
        description = "Server profiles. Each key becomes a <name>.conf file.";
      };

      accountProfiles = lib.mkOption {
        type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
        default = { };
        example = lib.literalExpression ''
          {
            "default.user" = {
              "posixAccount_homeDirectory" = "/home/$user";
              "posixAccount_loginShell" = "/bin/bash";
            };
          }
        '';
        description = ''
          Account profiles. Each key becomes a file in
          templates/profiles/ (e.g. "default.user").
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.phpfpm.pools.lam = {
      user = "lam";
      phpPackage = php;
      phpEnv.LOCALE_ARCHIVE = "${config.i18n.glibcLocales}/lib/locale/locale-archive";
      settings = lib.mapAttrs (_name: lib.mkDefault) {
        "listen.owner" = "nginx";
        "listen.group" = "nginx";
        "listen.mode" = "0600";
        "pm" = "dynamic";
        "pm.max_children" = 75;
        "pm.start_servers" = 1;
        "pm.min_spare_servers" = 1;
        "pm.max_spare_servers" = 4;
        "pm.max_requests" = 500;
        "pm.process_idle_timeout" = 30;
        "catch_workers_output" = 1;
      };
    };

    services.nginx = lib.mkIf (cfg.virtualHost != null) {
      enable = true;
      virtualHosts."${cfg.virtualHost}" = {
        root = "${cfg.package}/share/lam";
        locations = {
          "/" = {
            index = "index.html";
            tryFiles = "$uri $uri/ /index.html";
          };
          "~ /config/" = {
            extraConfig = ''
              deny all;
              return 404;
            '';
          };
          "~ \\.php$" = {
            extraConfig = ''
              try_files $fastcgi_script_name =404;
              include                   ${config.services.nginx.package}/conf/fastcgi.conf;
              fastcgi_split_path_info   ^(.+\.php)(.*)$;
              fastcgi_pass              unix:${config.services.phpfpm.pools.lam.socket};
              fastcgi_param             SCRIPT_FILENAME  $document_root$fastcgi_script_name;
              fastcgi_param             PATH_INFO        $fastcgi_path_info;
            '';
          };
        };
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      80
      443
    ];

    systemd.services.phpfpm-lam = {
      preStart = ''
        configDir="${cfg.stateDir}/config"

        ${seedConfigs}

        for subdir in language selfService templates; do
          if [ -d "${cfg.package}/share/lam/config/$subdir" ] && [ ! -d "$configDir/$subdir" ]; then
            cp -a "${cfg.package}/share/lam/config/$subdir" "$configDir/$subdir"
          fi
        done

        ${lib.optionalString (cfg.accountProfiles != { }) ''
          mkdir -p "$configDir/templates/profiles"
          for f in ${accountProfileDir}/*; do
            cp "$f" "$configDir/templates/profiles/$(basename "$f")"
          done
        ''}
      '';
      serviceConfig = {
        ReadWritePaths = [ cfg.stateDir ];
        BindPaths = [
          "${cfg.stateDir}/config:${cfg.package}/share/lam/config"
          "${cfg.stateDir}/sess:${cfg.package}/share/lam/sess"
          "${cfg.stateDir}/tmp:${cfg.package}/share/lam/tmp"
        ];
      };
    };

    systemd.tmpfiles.settings."lam" = builtins.listToAttrs (
      map
        (
          { name, mode }:
          {
            name = "${cfg.stateDir}/${name}";
            value.d = {
              inherit mode;
              user = "lam";
              group = "lam";
            };
          }
        )
        [
          {
            name = "config";
            mode = "0750";
          }
          {
            name = "sess";
            mode = "0700";
          }
          {
            name = "tmp";
            mode = "0700";
          }
        ]
    );

    users.users.lam = {
      description = "LDAP Account Manager service user";
      isSystemUser = true;
      group = "lam";
    };

    users.groups.lam = { };
  };
}
