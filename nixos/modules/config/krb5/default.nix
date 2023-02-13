{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.krb5;

  # This is to provide support for old configuration options (as much as is
  # reasonable). This can be removed after 18.03 was released.
  defaultConfig = {
    libdefaults = optionalAttrs (cfg.defaultRealm != null)
      { default_realm = cfg.defaultRealm; };

    realms = optionalAttrs (lib.all (value: value != null) [
      cfg.defaultRealm cfg.kdc cfg.kerberosAdminServer
    ]) {
      ${cfg.defaultRealm} = {
        kdc = cfg.kdc;
        admin_server = cfg.kerberosAdminServer;
      };
    };

    domain_realm = optionalAttrs (lib.all (value: value != null) [
      cfg.domainRealm cfg.defaultRealm
    ]) {
      ".${cfg.domainRealm}" = cfg.defaultRealm;
      ${cfg.domainRealm} = cfg.defaultRealm;
    };
  };

  mergedConfig = (recursiveUpdate defaultConfig {
    inherit (config.krb5)
      kerberos libdefaults realms domain_realm capaths appdefaults plugins
      extraConfig config;
  });

  filterEmbeddedMetadata = value: if isAttrs value then
    (filterAttrs
      (attrName: attrValue: attrName != "_module" && attrValue != null)
        value)
    else value;

  indent = "  ";

  mkRelation = name: value:
    if (isList value) then
      concatMapStringsSep "\n" (mkRelation name) value
    else "${name} = ${mkVal value}";

  mkVal = value:
    if (value == true) then "true"
    else if (value == false) then "false"
    else if (isInt value) then (toString value)
    else if (isAttrs value) then
      let configLines = concatLists
        (map (splitString "\n")
          (mapAttrsToList mkRelation value));
      in
      (concatStringsSep "\n${indent}"
        ([ "{" ] ++ configLines))
      + "\n}"
    else value;

  mkMappedAttrsOrString = value: concatMapStringsSep "\n"
    (line: if builtins.stringLength line > 0
      then "${indent}${line}"
      else line)
    (splitString "\n"
      (if isAttrs value then
        concatStringsSep "\n"
            (mapAttrsToList mkRelation value)
        else value));

in {

  ###### interface

  options = {
    krb5 = {
      enable = mkEnableOption (lib.mdDoc "building krb5.conf, configuration file for Kerberos V");

      kerberos = mkOption {
        type = types.package;
        default = pkgs.krb5;
        defaultText = literalExpression "pkgs.krb5";
        example = literalExpression "pkgs.heimdal";
        description = lib.mdDoc ''
          The Kerberos implementation that will be present in
          `environment.systemPackages` after enabling this
          service.
        '';
      };

      libdefaults = mkOption {
        type = with types; either attrs lines;
        default = {};
        apply = attrs: filterEmbeddedMetadata attrs;
        example = literalExpression ''
          {
            default_realm = "ATHENA.MIT.EDU";
          };
        '';
        description = lib.mdDoc ''
          Settings used by the Kerberos V5 library.
        '';
      };

      realms = mkOption {
        type = with types; either attrs lines;
        default = {};
        example = literalExpression ''
          {
            "ATHENA.MIT.EDU" = {
              admin_server = "athena.mit.edu";
              kdc = [
                "athena01.mit.edu"
                "athena02.mit.edu"
              ];
            };
          };
        '';
        apply = attrs: filterEmbeddedMetadata attrs;
        description = lib.mdDoc "Realm-specific contact information and settings.";
      };

      domain_realm = mkOption {
        type = with types; either attrs lines;
        default = {};
        example = literalExpression ''
          {
            "example.com" = "EXAMPLE.COM";
            ".example.com" = "EXAMPLE.COM";
          };
        '';
        apply = attrs: filterEmbeddedMetadata attrs;
        description = lib.mdDoc ''
          Map of server hostnames to Kerberos realms.
        '';
      };

      capaths = mkOption {
        type = with types; either attrs lines;
        default = {};
        example = literalExpression ''
          {
            "ATHENA.MIT.EDU" = {
              "EXAMPLE.COM" = ".";
            };
            "EXAMPLE.COM" = {
              "ATHENA.MIT.EDU" = ".";
            };
          };
        '';
        apply = attrs: filterEmbeddedMetadata attrs;
        description = lib.mdDoc ''
          Authentication paths for non-hierarchical cross-realm authentication.
        '';
      };

      appdefaults = mkOption {
        type = with types; either attrs lines;
        default = {};
        example = literalExpression ''
          {
            pam = {
              debug = false;
              ticket_lifetime = 36000;
              renew_lifetime = 36000;
              max_timeout = 30;
              timeout_shift = 2;
              initial_timeout = 1;
            };
          };
        '';
        apply = attrs: filterEmbeddedMetadata attrs;
        description = lib.mdDoc ''
          Settings used by some Kerberos V5 applications.
        '';
      };

      plugins = mkOption {
        type = with types; either attrs lines;
        default = {};
        example = literalExpression ''
          {
            ccselect = {
              disable = "k5identity";
            };
          };
        '';
        apply = attrs: filterEmbeddedMetadata attrs;
        description = lib.mdDoc ''
          Controls plugin module registration.
        '';
      };

      extraConfig = mkOption {
        type = with types; nullOr lines;
        default = null;
        example = ''
          [logging]
            kdc          = SYSLOG:NOTICE
            admin_server = SYSLOG:NOTICE
            default      = SYSLOG:NOTICE
        '';
        description = lib.mdDoc ''
          These lines go to the end of `krb5.conf` verbatim.
          `krb5.conf` may include any of the relations that are
          valid for `kdc.conf` (see `man kdc.conf`),
          but it is not a recommended practice.
        '';
      };

      config = mkOption {
        type = with types; nullOr lines;
        default = null;
        example = ''
          [libdefaults]
            default_realm = EXAMPLE.COM

          [realms]
            EXAMPLE.COM = {
              admin_server = kerberos.example.com
              kdc = kerberos.example.com
              default_principal_flags = +preauth
            }

          [domain_realm]
            example.com  = EXAMPLE.COM
            .example.com = EXAMPLE.COM

          [logging]
            kdc          = SYSLOG:NOTICE
            admin_server = SYSLOG:NOTICE
            default      = SYSLOG:NOTICE
        '';
        description = lib.mdDoc ''
          Verbatim `krb5.conf` configuration.  Note that this
          is mutually exclusive with configuration via
          `libdefaults`, `realms`,
          `domain_realm`, `capaths`,
          `appdefaults`, `plugins` and
          `extraConfig` configuration options.  Consult
          `man krb5.conf` for documentation.
        '';
      };

      defaultRealm = mkOption {
        type = with types; nullOr str;
        default = null;
        example = "ATHENA.MIT.EDU";
        description = lib.mdDoc ''
          DEPRECATED, please use
          `krb5.libdefaults.default_realm`.
        '';
      };

      domainRealm = mkOption {
        type = with types; nullOr str;
        default = null;
        example = "athena.mit.edu";
        description = lib.mdDoc ''
          DEPRECATED, please create a map of server hostnames to Kerberos realms
          in `krb5.domain_realm`.
        '';
      };

      kdc = mkOption {
        type = with types; nullOr str;
        default = null;
        example = "kerberos.mit.edu";
        description = lib.mdDoc ''
          DEPRECATED, please pass a `kdc` attribute to a realm
          in `krb5.realms`.
        '';
      };

      kerberosAdminServer = mkOption {
        type = with types; nullOr str;
        default = null;
        example = "kerberos.mit.edu";
        description = lib.mdDoc ''
          DEPRECATED, please pass an `admin_server` attribute
          to a realm in `krb5.realms`.
        '';
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ cfg.kerberos ];

    environment.etc."krb5.conf".text = if isString cfg.config
      then cfg.config
      else (''
        [libdefaults]
        ${mkMappedAttrsOrString mergedConfig.libdefaults}

        [realms]
        ${mkMappedAttrsOrString mergedConfig.realms}

        [domain_realm]
        ${mkMappedAttrsOrString mergedConfig.domain_realm}

        [capaths]
        ${mkMappedAttrsOrString mergedConfig.capaths}

        [appdefaults]
        ${mkMappedAttrsOrString mergedConfig.appdefaults}

        [plugins]
        ${mkMappedAttrsOrString mergedConfig.plugins}
      '' + optionalString (mergedConfig.extraConfig != null)
          ("\n" + mergedConfig.extraConfig));

    warnings = flatten [
      (optional (cfg.defaultRealm != null) ''
        The option krb5.defaultRealm is deprecated, please use
        krb5.libdefaults.default_realm.
      '')
      (optional (cfg.domainRealm != null) ''
        The option krb5.domainRealm is deprecated, please use krb5.domain_realm.
      '')
      (optional (cfg.kdc != null) ''
        The option krb5.kdc is deprecated, please pass a kdc attribute to a
        realm in krb5.realms.
      '')
      (optional (cfg.kerberosAdminServer != null) ''
        The option krb5.kerberosAdminServer is deprecated, please pass an
        admin_server attribute to a realm in krb5.realms.
      '')
    ];

    assertions = [
      { assertion = !((builtins.any (value: value != null) [
            cfg.defaultRealm cfg.domainRealm cfg.kdc cfg.kerberosAdminServer
          ]) && ((builtins.any (value: value != {}) [
              cfg.libdefaults cfg.realms cfg.domain_realm cfg.capaths
              cfg.appdefaults cfg.plugins
            ]) || (builtins.any (value: value != null) [
              cfg.config cfg.extraConfig
            ])));
        message = ''
          Configuration of krb5.conf by deprecated options is mutually exclusive
          with configuration by section.  Please migrate your config using the
          attributes suggested in the warnings.
        '';
      }
      { assertion = !(cfg.config != null
          && ((builtins.any (value: value != {}) [
              cfg.libdefaults cfg.realms cfg.domain_realm cfg.capaths
              cfg.appdefaults cfg.plugins
            ]) || (builtins.any (value: value != null) [
              cfg.extraConfig cfg.defaultRealm cfg.domainRealm cfg.kdc
              cfg.kerberosAdminServer
            ])));
        message = ''
          Configuration of krb5.conf using krb.config is mutually exclusive with
          configuration by section.  If you want to mix the two, you can pass
          lines to any configuration section or lines to krb5.extraConfig.
        '';
      }
    ];
  };
}
