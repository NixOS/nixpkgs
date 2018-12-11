{ pkgs, config, lib, ... } :

let
  inherit (lib) mkIf concatStrings concatStringsSep concatMapStrings toList
    mapAttrs mapAttrsToList attrValues;
  cfg = config.services.kerberos_server;
  kerberos = config.krb5.kerberos;
  stateDir = "/var/lib/krb5kdc";
  PIDFile = "/run/kdc.pid";
  aclMap = {
    add = "a"; cpw = "c"; delete = "d"; get = "i"; list = "l"; modify = "m";
    all = "*";
  };
  aclFiles = mapAttrs
    (name: {acl, ...}: (pkgs.writeText "${name}.acl" (concatMapStrings (
      {principal, access, target, ...} :
      let access_code = map (a: aclMap.${a}) (toList access); in
      "${principal} ${concatStrings access_code} ${target}\n"
    ) acl))) cfg.realms;
  kdcConfigs = mapAttrsToList (name: value: ''
    ${name} = {
      acl_file = ${value}
    }
  '') aclFiles;
  kdcConfFile = pkgs.writeText "kdc.conf" ''
    [realms]
    ${concatStringsSep "\n" kdcConfigs}
  '';
  env = {
    # What Debian uses, could possibly link directly to Nix store?
    KRB5_KDC_PROFILE = "/etc/krb5kdc/kdc.conf";
  };
in

{
  config = mkIf (cfg.enable && kerberos == pkgs.krb5Full) {
    systemd.services.kadmind = {
      description = "Kerberos Administration Daemon";
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -m 0755 -p ${stateDir}
      '';
      serviceConfig.ExecStart = "${kerberos}/bin/kadmind -nofork";
      restartTriggers = [ kdcConfFile ];
      environment = env;
    };

    systemd.services.kdc = {
      description = "Key Distribution Center daemon";
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -m 0755 -p ${stateDir}
      '';
      serviceConfig = {
        Type = "forking";
        PIDFile = PIDFile;
        ExecStart = "${kerberos}/bin/krb5kdc -P ${PIDFile}";
      };
      restartTriggers = [ kdcConfFile ];
      environment = env;
    };

    environment.etc = {
      "krb5kdc/kdc.conf".source = kdcConfFile;
    };
    environment.variables = env;
  };
}
