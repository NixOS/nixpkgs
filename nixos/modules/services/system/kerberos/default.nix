{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkOption types;
  inherit (lib.types) listOf str;
  cfg = config.services.kerberos_server;
  inherit (config.security.krb5) package;

  format = import ../../../security/krb5/krb5-conf-format.nix { inherit pkgs lib; } {
    enableKdcACLEntries = true;
  };
in

{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "kerberos_server" "realms" ]
      [ "services" "kerberos_server" "settings" "realms" ]
    )

    ./mit.nix
    ./heimdal.nix
  ];

  options = {
    services.kerberos_server = {
      enable = lib.mkEnableOption "the kerberos authentication server";

      settings = mkOption {
        type = format.type;
        description = ''
          Settings for the kerberos server of choice.

          See the following documentation:
          - Heimdal: {manpage}`kdc.conf(5)`
          - MIT Kerberos: <https://web.mit.edu/kerberos/krb5-1.21/doc/admin/conf_files/kdc_conf.html>
        '';
        default = { };
      };

      extraKDCArgs = mkOption {
        type = listOf str;
        description = ''
          Extra arguments to pass to the KDC process. See {manpage}`kdc(8)`.
        '';
        default = [ ];
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
      {
        assertion =
          let
            inherit (builtins) attrValues elem length;
            realms = attrValues cfg.settings.realms;
            accesses = lib.concatMap (r: map (a: a.access) r.acl) realms;
            property = a: !elem "all" a || (length a <= 1) || (length a <= 2 && elem "get-keys" a);
          in
          builtins.all property accesses;
        message = "Cannot specify \"all\" in a list with additional permissions other than \"get-keys\"";
      }
    ];

    systemd.slices.system-kerberos-server = { };
    systemd.targets.kerberos-server = {
      wantedBy = [ "multi-user.target" ];
    };
  };

  meta = {
    doc = ./kerberos-server.md;
  };
}
