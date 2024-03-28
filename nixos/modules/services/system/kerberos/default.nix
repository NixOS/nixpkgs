{ config, pkgs, lib, ... }:

let
  inherit (lib) mkOption types;
  cfg = config.services.kerberos_server;
  inherit (config.security.krb5) package;

  format = import ../../../security/krb5/krb5-conf-format.nix { inherit pkgs lib; } { };
in

{
  imports = [
    (lib.mkRenamedOptionModule [ "services" "kerberos_server" "realms" ] [ "services" "kerberos_server" "settings" "realms" ])

    ./mit.nix
    ./heimdal.nix
  ];

  options = {
    services.kerberos_server = {
      enable = lib.mkEnableOption (lib.mdDoc "the kerberos authentication server");

      settings = let
        aclEntry = types.submodule {
          options = {
            principal = mkOption {
              type = types.str;
              description = lib.mdDoc "Which principal the rule applies to";
            };
            access = mkOption {
              type = types.either
                (types.listOf (types.enum ["add" "cpw" "delete" "get" "list" "modify"]))
                (types.enum ["all"]);
              default = "all";
              description = lib.mdDoc "The changes the principal is allowed to make.";
            };
            target = mkOption {
              type = types.str;
              default = "*";
              description = lib.mdDoc "The principals that 'access' applies to.";
            };
          };
        };

        realm = types.submodule ({ name, ... }: {
          freeformType = format.sectionType;
          options = {
            acl = mkOption {
              type = types.listOf aclEntry;
              default = [
                { principal = "*/admin"; access = "all"; }
                { principal = "admin"; access = "all"; }
              ];
              description = lib.mdDoc ''
                The privileges granted to a user.
              '';
            };
          };
        });
      in mkOption {
        type = types.submodule (format.type.getSubModules ++ [{
          options = {
            realms = mkOption {
              type = types.attrsOf realm;
              description = lib.mdDoc ''
                The realm(s) to serve keys for.
              '';
            };
          };
        }]);
        description = ''
          Settings for the kerberos server of choice.

          See the following documentation:
          - Heimdal: {manpage}`kdc.conf(5)`
          - MIT Kerberos: <https://web.mit.edu/kerberos/krb5-1.21/doc/admin/conf_files/kdc_conf.html>
        '';
        default = { };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ package ];
    assertions = [
      {
        assertion = cfg.settings.realms != { };
        message = "The server needs at least one realm";
      }
      {
        assertion = lib.length (lib.attrNames cfg.settings.realms) <= 1;
        message = "Only one realm per server is currently supported.";
      }
    ];

    systemd.slices.system-kerberos-server = { };
    systemd.targets.kerberos-server = {
      wantedBy = [ "multi-user.target" ];
    };
  };
}
