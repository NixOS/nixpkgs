{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.services.privatebin;

  customToINI = lib.generators.toINI {
    mkKeyValue = lib.generators.mkKeyValueDefault {
      mkValueString =
        v:
        if v == true then
          ''true''
        else if v == false then
          ''false''
        else if builtins.isInt v then
          ''${builtins.toString v}''
        else if builtins.isPath v then
          ''"${builtins.toString v}"''
        else if builtins.isString v then
          ''"${v}"''
        else
          lib.generators.mkValueStringDefault { } v;
    } "=";
  };

  privatebinSettings = pkgs.writeTextDir "conf.php" (customToINI cfg.settings);

  user = cfg.user;
  group = cfg.group;

  defaultUser = "privatebin";
  defaultGroup = "privatebin";

in
{

  options.services.privatebin = {

    enable = lib.mkEnableOption "Privatebin: A minimalist, open source online
      pastebin where the server has zero knowledge of pasted data.";

    user = lib.mkOption {
      type = lib.types.str;
      default = defaultUser;
      description = "User account under which privatebin runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = if cfg.enableNginx then "nginx" else defaultGroup;
      defaultText = lib.literalExpression "if config.services.privatebin.enableNginx then \"nginx\" else \"${defaultGroup}\"";
      description = ''
        Group under which privatebin runs. It is best to set this to the group
        of whatever webserver is being used as the frontend.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/privatebin";
      description = ''
        The place where privatebin stores its state.
      '';
    };

    package = lib.mkPackageOption pkgs "privatebin" { };

    enableNginx = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable nginx or not. If enabled, an nginx virtual host will
        be created for access to privatebin. If not enabled, then you may use
        `''${config.services.privatebin.package}` as your document root in
        whichever webserver you wish to setup.
      '';
    };

    virtualHost = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = ''
        The hostname at which you wish privatebin to be served. If you have
        enabled nginx using `services.privatebin.enableNginx` then this will
        be used.
      '';
    };

    poolConfig = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.oneOf [
          lib.types.str
          lib.types.int
          lib.types.bool
        ]
      );
      defaultText = lib.literalExpression ''
        {
          "pm" = "dynamic";
          "pm.max_children" = 32;
          "pm.start_servers" = 2;
          "pm.min_spare_servers" = 2;
          "pm.max_spare_servers" = 4;
          "pm.max_requests" = 500;
        }
      '';
      default = { };
      description = ''
        Options for the PrivateBin PHP pool. See the documentation on <literal>php-fpm.conf</literal>
        for details on configuration directives.
      '';
    };

    settings = lib.mkOption {
      default = { };
      description = ''
        Options for privatebin configuration. Refer to
        <https://github.com/PrivateBin/PrivateBin/wiki/Configuration> for
        details on supported values.
      '';
      example = lib.literalExpression ''
        {
          main = {
            name = "NixOS Based Privatebin";
            discussion = false;
            defaultformatter = "plalib.types.intext";
            qrcode = true
          };
          model.class = "Filesystem";
          model_options.dir = "/var/lib/privatebin/data";
        }
      '';
      type = lib.types.submodule { freeformType = lib.types.attrsOf lib.types.anything; };
    };
  };

  config = lib.mkIf cfg.enable {
    services.privatebin.settings = {
      main = lib.mkDefault { };
      model.class = lib.mkDefault "Filesystem";
      model_options.dir = lib.mkDefault "${cfg.dataDir}/data";
      purge.dir = lib.mkDefault "${cfg.dataDir}/purge";
      traffic = {
        dir = lib.mkDefault "${cfg.dataDir}/traffic";
        header = "X_FORWARDED_FOR";
      };
    };

    services.phpfpm.pools.privatebin = {
      inherit user group;
      phpPackage = pkgs.php83;
      phpOptions = ''
        log_errors = on
      '';
      settings = {
        "listen.mode" = lib.mkDefault "0660";
        "listen.owner" = lib.mkDefault user;
        "listen.group" = lib.mkDefault group;
        "pm" = lib.mkDefault "dynamic";
        "pm.max_children" = lib.mkDefault 32;
        "pm.start_servers" = lib.mkDefault 2;
        "pm.min_spare_servers" = lib.mkDefault 2;
        "pm.max_spare_servers" = lib.mkDefault 4;
        "pm.max_requests" = lib.mkDefault 500;
      };
      phpEnv.CONFIG_PATH = lib.strings.removeSuffix "/conf.php" (builtins.toString privatebinSettings);
    };

    services.nginx = lib.mkIf cfg.enableNginx {
      enable = true;
      recommendedTlsSettings = lib.mkDefault true;
      recommendedOptimisation = lib.mkDefault true;
      recommendedGzipSettings = lib.mkDefault true;
      virtualHosts.${cfg.virtualHost} = {
        root = "${cfg.package}";
        locations = {
          "/" = {
            tryFiles = "$uri $uri/ /index.php?$query_string";
            index = "index.php";
            extraConfig = ''
              sendfile off;
            '';
          };
          "~ \\.php$" = {
            extraConfig = ''
              include ${config.services.nginx.package}/conf/fastcgi_params ;
              fastcgi_param SCRIPT_FILENAME $request_filename;
              fastcgi_param modHeadersAvailable true; #Avoid sending the security headers twice
              fastcgi_pass unix:${config.services.phpfpm.pools.privatebin.socket};
            '';
          };
        };
      };
    };

    systemd.tmpfiles.settings."10-privatebin" =
      lib.attrsets.genAttrs
        [
          "${cfg.dataDir}/data"
          "${cfg.dataDir}/traffic"
          "${cfg.dataDir}/purge"
        ]
        (n: {
          d = {
            group = group;
            mode = "0750";
            user = user;
          };
        });

    users = {
      users = lib.mkIf (user == defaultUser) {
        ${defaultUser} = {
          description = "Privatebin service user";
          inherit group;
          isSystemUser = true;
          home = cfg.dataDir;
        };
      };
      groups = lib.mkIf (group == defaultGroup) { ${defaultGroup} = { }; };
    };
  };
}
