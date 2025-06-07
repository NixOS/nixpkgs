{
  pkgs,
  config,
  lib,
  utils,
  ...
}:

let
  inherit (lib) mapAttrs;
  inherit (utils) escapeSystemdExecArgs;

  cfg = config.services.kerberos_server;
  package = config.security.krb5.package;

  aclConfigs = lib.pipe cfg.settings.realms [
    (mapAttrs (
      name:
      { acl, ... }:
      lib.concatMapStringsSep "\n" (
        {
          principal,
          access,
          target,
          ...
        }:
        if target != "*" && target != "" then
          "${principal}\t${lib.concatStringsSep "," (lib.toList access)}\t${target}"
        else
          "${principal}\t${lib.concatStringsSep "," (lib.toList access)}"
      ) acl
    ))
    (lib.mapAttrsToList (
      name: text: {
        dbname = "/var/lib/heimdal/heimdal";
        acl_file = pkgs.writeText "${name}.acl" text;
      }
    ))
  ];

  finalConfig = cfg.settings // {
    realms = mapAttrs (_: v: removeAttrs v [ "acl" ]) (cfg.settings.realms or { });
    kdc = (cfg.settings.kdc or { }) // {
      database = aclConfigs;
    };
  };

  format = import ../../../security/krb5/krb5-conf-format.nix { inherit pkgs lib; } {
    enableKdcACLEntries = true;
  };

  kdcConfFile = format.generate "kdc.conf" finalConfig;
in

{
  config = lib.mkIf (cfg.enable && package.passthru.implementation == "heimdal") {
    environment.etc."heimdal-kdc/kdc.conf".source = kdcConfFile;

    systemd.tmpfiles.settings."10-heimdal" =
      let
        databases = lib.pipe finalConfig.kdc.database [
          (map (dbAttrs: dbAttrs.dbname or null))
          (lib.filter (x: x != null))
          lib.unique
        ];
      in
      lib.genAttrs databases (_: {
        d = {
          user = "root";
          group = "root";
          mode = "0700";
        };
      });

    systemd.services.kadmind = {
      description = "Kerberos Administration Daemon";
      partOf = [ "kerberos-server.target" ];
      wantedBy = [ "kerberos-server.target" ];
      documentation = [
        "man:kadmind(8)"
        "info:heimdal"
      ];
      serviceConfig = {
        ExecStart = "${package}/libexec/kadmind --config-file=/etc/heimdal-kdc/kdc.conf";
        Slice = "system-kerberos-server.slice";
        StateDirectory = "heimdal";
      };
      restartTriggers = [ kdcConfFile ];
    };

    systemd.services.kdc = {
      description = "Key Distribution Center daemon";
      partOf = [ "kerberos-server.target" ];
      wantedBy = [ "kerberos-server.target" ];
      documentation = [
        "man:kdc(8)"
        "info:heimdal"
      ];
      serviceConfig = {
        ExecStart = escapeSystemdExecArgs (
          [
            "${package}/libexec/kdc"
            "--config-file=/etc/heimdal-kdc/kdc.conf"
          ]
          ++ cfg.extraKDCArgs
        );
        Slice = "system-kerberos-server.slice";
        StateDirectory = "heimdal";
      };
      restartTriggers = [ kdcConfFile ];
    };

    systemd.services.kpasswdd = {
      description = "Kerberos Password Changing daemon";
      partOf = [ "kerberos-server.target" ];
      wantedBy = [ "kerberos-server.target" ];
      documentation = [
        "man:kpasswdd(8)"
        "info:heimdal"
      ];
      serviceConfig = {
        ExecStart = "${package}/libexec/kpasswdd";
        Slice = "system-kerberos-server.slice";
        StateDirectory = "heimdal";
      };
      restartTriggers = [ kdcConfFile ];
    };
  };
}
