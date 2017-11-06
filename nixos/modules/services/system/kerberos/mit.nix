{ pkgs, config, lib, ... } :

let
  inherit (lib) mkIf concatStrings concatStringsSep concatMapStrings toList
    mapAttrs' nameValuePair attrNames attrValues;
  cfg = config.services.kerberos_server;
  kerberos = config.krb5.kerberos;
  stateDir = "/var/lib/krb5kdc";
  PIDFile = "/run/kdc.pid";
  aclMap = {
    add = "a"; cpw = "c"; delete = "d"; get = "i"; list = "l"; modify = "m";
    all = "*";
  };
  aclFiles = mapAttrs'
    (name: {acl, ...}: nameValuePair "${name}.acl" (
      pkgs.writeText "${name}.acl" (concatMapStrings (
        {principal, access, target, ...} :
        let access_code = map (a: aclMap.${a}) (toList access); in
        "${principal} ${concatStrings access_code} ${target}\n"
      ) acl)
    )) cfg.realms;
  kdcConfigs = map (name: ''
    ${name} = {
      acl_file = /etc/krb5kdc/${name}.acl
    }
  '') (attrNames cfg.realms);
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
      restartTriggers = [ kdcConfFile ] ++ (attrValues aclFiles);
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
    } // (
      mapAttrs'
      (name: value: nameValuePair "krb5kdc/${name}" {source = value;})
      aclFiles
    );
    environment.variables = env;
  };
}
