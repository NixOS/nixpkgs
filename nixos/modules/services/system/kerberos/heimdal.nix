{ pkgs, config, lib, ... } :

let
  inherit (lib) mkIf concatStringsSep concatMapStrings toList mapAttrs
    mapAttrsToList attrValues;
  cfg = config.services.kerberos_server;
  kerberos = config.krb5.kerberos;
  stateDir = "/var/heimdal";
  aclFiles = mapAttrs
    (name: {acl, ...}: pkgs.writeText "${name}.acl" (concatMapStrings ((
      {principal, access, target, ...} :
      "${principal}\t${concatStringsSep "," (toList access)}\t${target}\n"
    )) acl)) cfg.realms;

  kdcConfigs = mapAttrsToList (name: value: ''
    database = {
      dbname = ${stateDir}/heimdal
      acl_file = ${value}
    }
  '') aclFiles;
  kdcConfFile = pkgs.writeText "kdc.conf" ''
    [kdc]
    ${concatStringsSep "\n" kdcConfigs}
  '';
in

{
  # No documentation about correct triggers, so guessing at them.

  config = mkIf (cfg.enable && kerberos == pkgs.heimdalFull) {
    systemd.services.kadmind = {
      description = "Kerberos Administration Daemon";
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -m 0755 -p ${stateDir}
      '';
      serviceConfig.ExecStart =
        "${kerberos}/libexec/heimdal/kadmind --config-file=/etc/heimdal-kdc/kdc.conf";
      restartTriggers = [ kdcConfFile ];
    };

    systemd.services.kdc = {
      description = "Key Distribution Center daemon";
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -m 0755 -p ${stateDir}
      '';
      serviceConfig.ExecStart =
        "${kerberos}/libexec/heimdal/kdc --config-file=/etc/heimdal-kdc/kdc.conf";
      restartTriggers = [ kdcConfFile ];
    };

    systemd.services.kpasswdd = {
      description = "Kerberos Password Changing daemon";
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -m 0755 -p ${stateDir}
      '';
      serviceConfig.ExecStart = "${kerberos}/libexec/heimdal/kpasswdd";
      restartTriggers = [ kdcConfFile ];
    };

    environment.etc = {
      # Can be set via the --config-file option to KDC
      "heimdal-kdc/kdc.conf".source = kdcConfFile;
    };
  };
}
