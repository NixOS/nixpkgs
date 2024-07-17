{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkOption types;
  cfg = config.services.kerberos_server;
  inherit (config.security.krb5) package;

  format = import ../../../security/krb5/krb5-conf-format.nix { inherit pkgs lib; } {
    enableKdcACLEntries = true;
  };
in

{
  imports = [
    (lib.mkRenamedOptionModule
      [
        "services"
        "kerberos_server"
        "realms"
      ]
      [
        "services"
        "kerberos_server"
        "settings"
        "realms"
      ]
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

  meta = {
    doc = ./kerberos-server.md;
  };
}
