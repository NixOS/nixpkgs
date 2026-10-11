{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    concatMapStringsSep
    concatStringsSep
    escape
    literalExpression
    mapAttrsToList
    mkAliasOptionModule
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.services.fourget;

  toPhpVal =
    v:
    if builtins.isNull v then
      "null"
    else if builtins.isBool v then
      (if v then "true" else "false")
    else if builtins.isInt v then
      toString v
    else if builtins.isString v then
      "\"${escape [ "\"" "\\" ] v}\""
    else if builtins.isList v then
      "[ " + (concatMapStringsSep ", " toPhpVal v) + " ]"
    else if builtins.isAttrs v then
      "[ " + (concatStringsSep ", " (mapAttrsToList (k: val: "\"${k}\" => " + toPhpVal val) v)) + " ]"
    else
      toString v;

  configContent = ''
    <?php
    if (!class_exists("default_config")) {
        require_once "${cfg.package}/data/config.default.php";
    }

    class config extends default_config {
    ${concatStringsSep "\n" (
      mapAttrsToList (name: value: "  const ${name} = ${toPhpVal value};") cfg.settings
    )}
    }

    ${cfg.extraConfig}
  '';

  configFile = pkgs.writeText "fourget-config.php" configContent;

  servedRoot = pkgs.runCommand "fourget-served-root" { } ''
    mkdir -p $out
    cp --reflink=auto --no-preserve=mode -r ${cfg.package}/* $out/

    rm -rf $out/icons
    ln -sf ${cfg.stateDir}/icons $out/icons

    mkdir -p $out/data
    rm -rf $out/data/sessions
    ln -sf ${cfg.stateDir}/sessions $out/data/sessions
  '';

  phpPackage = cfg.phpPackage.withExtensions (
    { all, ... }: with all;
    [
      imagick
      apcu
    ]
  );
in
{
  imports = [
    (mkAliasOptionModule [ "services" "_4get" ] [ "services" "fourget" ])
  ];

  options.services.fourget = {
    enable = mkEnableOption "4get, a privacy-respecting metasearch engine";

    package = mkPackageOption pkgs "_4get" { };

    finalPackage = mkOption {
      type = types.package;
      default = servedRoot;
      defaultText = literalExpression "servedRoot";
      readOnly = true;
      description = ''
        The finalized 4get root package containing the web application source
        with symlinks to the state directory.
      '';
    };

    stateDir = mkOption {
      type = types.path;
      default = "/var/lib/fourget";
      description = ''
        State directory for 4get, storing cached icons and session databases.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "fourget";
      description = "User account under which fourget runs.";
    };

    group = mkOption {
      type = types.str;
      default = "fourget";
      description = "Group account under which fourget runs.";
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = types.attrsOf types.anything;
        options = {
          SERVER_NAME = mkOption {
            type = types.str;
            default = "4get";
            description = "Server name displayed on pages.";
          };

          DEFAULT_THEME = mkOption {
            type = types.str;
            default = "Dark";
            description = "Default theme to use.";
          };
        };
      };
      default = { };
      description = ''
        Configuration constants for 4get. These override the default values in
        <filename>data/config.php</filename>.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Extra PHP code appended to the 4get configuration file.
      '';
    };

    enableCurlImpersonate = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to load curl-impersonate in PHP-FPM to bypass browser integrity
        checks on certain search engines.
      '';
    };

    phpPackage = mkPackageOption pkgs "php" { };

    poolConfig = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = ''
        Extra configuration options for the 4get PHP-FPM pool.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.phpfpm.pools.fourget = {
      inherit (cfg) user group;
      inherit phpPackage;
      phpEnv = {
        FOURGET_CONFIG = "${configFile}";
      }
      // lib.optionalAttrs cfg.enableCurlImpersonate {
        LD_PRELOAD = "${pkgs.curl-impersonate}/lib/libcurl-impersonate.so";
        CURL_IMPERSONATE = "firefox117";
      };
      settings = {
        "listen.owner" = mkDefault (
          if config.services.nginx.enable then
            config.services.nginx.user
          else if config.services.caddy.enable then
            config.services.caddy.user
          else
            cfg.user
        );
        "listen.group" = mkDefault (
          if config.services.nginx.enable then
            config.services.nginx.group
          else if config.services.caddy.enable then
            config.services.caddy.group
          else
            cfg.group
        );
        "listen.mode" = mkDefault "0660";
        "chdir" = "${servedRoot}";
        "pm" = mkDefault "dynamic";
        "pm.max_children" = mkDefault 32;
        "pm.start_servers" = mkDefault 2;
        "pm.min_spare_servers" = mkDefault 1;
        "pm.max_spare_servers" = mkDefault 4;
      }
      // cfg.poolConfig;
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.stateDir} 0755 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.stateDir}/icons 0755 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.stateDir}/sessions 0700 ${cfg.user} ${cfg.group} - -"
    ];

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      description = "4get service user";
      home = cfg.stateDir;
    };

    users.groups.${cfg.group} = { };
  };

  meta.maintainers = with lib.maintainers; [ gs-101 ];
}
