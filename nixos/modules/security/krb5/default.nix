{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption mkPackageOption mkRemovedOptionModule;
  inherit (lib.types) bool;

  mkRemovedOptionModule' = name: reason: mkRemovedOptionModule ["krb5" name] reason;
  mkRemovedOptionModuleCfg = name: mkRemovedOptionModule' name ''
    The option `krb5.${name}' has been removed. Use
    `security.krb5.settings.${name}' for structured configuration.
  '';

  cfg = config.security.krb5;
  format = import ./krb5-conf-format.nix { inherit pkgs lib; } { };
in {
  imports = [
    (mkRemovedOptionModuleCfg "libdefaults")
    (mkRemovedOptionModuleCfg "realms")
    (mkRemovedOptionModuleCfg "domain_realm")
    (mkRemovedOptionModuleCfg "capaths")
    (mkRemovedOptionModuleCfg "appdefaults")
    (mkRemovedOptionModuleCfg "plugins")
    (mkRemovedOptionModuleCfg "config")
    (mkRemovedOptionModuleCfg "extraConfig")
    (mkRemovedOptionModule' "kerberos" ''
      The option `krb5.kerberos' has been moved to `security.krb5.package'.
    '')
  ];

  options = {
    security.krb5 = {
      enable = mkOption {
        default = false;
        description = "Enable and configure Kerberos utilities";
        type = bool;
      };

      package = mkPackageOption pkgs "krb5" {
        example = "heimdal";
      };

      settings = mkOption {
        default = { };
        type = format.type;
        description = ''
          Structured contents of the {file}`krb5.conf` file. See
          {manpage}`krb5.conf(5)` for details about configuration.
        '';
        example = {
          include = [ "/run/secrets/secret-krb5.conf" ];
          includedir = [ "/run/secrets/secret-krb5.conf.d" ];

          libdefaults = {
            default_realm = "ATHENA.MIT.EDU";
          };

          realms = {
            "ATHENA.MIT.EDU" = {
              admin_server = "athena.mit.edu";
              kdc = [
                "athena01.mit.edu"
                "athena02.mit.edu"
              ];
            };
          };

          domain_realm = {
            "mit.edu" = "ATHENA.MIT.EDU";
          };

          logging = {
            kdc = "SYSLOG:NOTICE";
            admin_server = "SYSLOG:NOTICE";
            default = "SYSLOG:NOTICE";
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];
      etc."krb5.conf".source = format.generate "krb5.conf" cfg.settings;
    };
  };

  meta.maintainers = builtins.attrValues {
    inherit (lib.maintainers) dblsaiko h7x4;
  };
}
