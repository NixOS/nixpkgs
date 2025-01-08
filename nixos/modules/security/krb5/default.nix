{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.types) bool;

  mkRemovedOptionModule' = name: reason: lib.mkRemovedOptionModule [ "krb5" name ] reason;
  mkRemovedOptionModuleCfg =
    name:
    mkRemovedOptionModule' name ''
      The option `krb5.${name}' has been removed. Use
      `security.krb5.settings.${name}' for structured configuration.
    '';

  cfg = config.security.krb5;
  format = import ./krb5-conf-format.nix { inherit pkgs lib; } { };
in
{
  imports = [
    (lib.mkRemovedOptionModuleCfg "libdefaults")
    (lib.mkRemovedOptionModuleCfg "realms")
    (lib.mkRemovedOptionModuleCfg "domain_realm")
    (lib.mkRemovedOptionModuleCfg "capaths")
    (lib.mkRemovedOptionModuleCfg "appdefaults")
    (lib.mkRemovedOptionModuleCfg "plugins")
    (lib.mkRemovedOptionModuleCfg "config")
    (lib.mkRemovedOptionModuleCfg "extraConfig")
    (lib.mkRemovedOptionModule' "kerberos" ''
      The option `krb5.kerberos' has been moved to `security.krb5.package'.
    '')
  ];

  options = {
    security.krb5 = {
      enable = lib.mkOption {
        default = false;
        description = "Enable and configure Kerberos utilities";
        type = bool;
      };

      package = lib.mkPackageOption pkgs "krb5" {
        example = "heimdal";
      };

      settings = lib.mkOption {
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

  config = {
    assertions = lib.mkIf (cfg.enable || config.services.kerberos_server.enable) [
      (
        let
          implementation = cfg.package.passthru.implementation or "<NOT SET>";
        in
        {
          assertion = lib.elem implementation [
            "krb5"
            "heimdal"
          ];
          message = ''
            `security.krb5.package` must be one of:

              - krb5
              - heimdal

            Currently chosen implementation: ${implementation}
          '';
        }
      )
    ];

    environment = lib.mkIf cfg.enable {
      systemPackages = [ cfg.package ];
      etc."krb5.conf".source = format.generate "krb5.conf" cfg.settings;
    };
  };

  meta.maintainers = builtins.attrValues {
    inherit (lib.maintainers) dblsaiko h7x4;
  };
}
