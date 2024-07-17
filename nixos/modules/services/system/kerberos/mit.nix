{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib) mapAttrs;
  cfg = config.services.kerberos_server;
  package = config.security.krb5.package;
  PIDFile = "/run/kdc.pid";

  format = import ../../../security/krb5/krb5-conf-format.nix { inherit pkgs lib; } {
    enableKdcACLEntries = true;
  };

  aclMap = {
    add = "a";
    cpw = "c";
    delete = "d";
    get = "i";
    list = "l";
    modify = "m";
    all = "*";
  };

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
        let
          access_code = map (a: aclMap.${a}) (lib.toList access);
        in
        "${principal} ${lib.concatStrings access_code} ${target}"
      ) acl
    ))

    (lib.concatMapAttrs (
      name: text: {
        ${name} = {
          acl_file = pkgs.writeText "${name}.acl" text;
        };
      }
    ))
  ];

  finalConfig = cfg.settings // {
    realms = mapAttrs (n: v: (removeAttrs v [ "acl" ]) // aclConfigs.${n}) (cfg.settings.realms or { });
  };

  kdcConfFile = format.generate "kdc.conf" finalConfig;
  env = {
    # What Debian uses, could possibly link directly to Nix store?
    KRB5_KDC_PROFILE = "/etc/krb5kdc/kdc.conf";
  };
in

{
  config = lib.mkIf (cfg.enable && package.passthru.implementation == "krb5") {
    environment = {
      etc."krb5kdc/kdc.conf".source = kdcConfFile;
      variables = env;
    };

    systemd.services.kadmind = {
      description = "Kerberos Administration Daemon";
      partOf = [ "kerberos-server.target" ];
      wantedBy = [ "kerberos-server.target" ];
      serviceConfig = {
        ExecStart = "${package}/bin/kadmind -nofork";
        Slice = "system-kerberos-server.slice";
        StateDirectory = "krb5kdc";
      };
      restartTriggers = [ kdcConfFile ];
      environment = env;
    };

    systemd.services.kdc = {
      description = "Key Distribution Center daemon";
      partOf = [ "kerberos-server.target" ];
      wantedBy = [ "kerberos-server.target" ];
      serviceConfig = {
        Type = "forking";
        PIDFile = PIDFile;
        ExecStart = "${package}/bin/krb5kdc -P ${PIDFile}";
        Slice = "system-kerberos-server.slice";
        StateDirectory = "krb5kdc";
      };
      restartTriggers = [ kdcConfFile ];
      environment = env;
    };
  };
}
