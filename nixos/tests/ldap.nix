import ./make-test.nix ({ pkgs, lib, ...} :

let

  dbSuffix = "dc=example,dc=com";
  dbPath = "/var/db/openldap";
  dbAdminDn = "cn=admin,${dbSuffix}";
  dbAdminPwd = "test";
  serverUri = "ldap:///";
  ldapUser = "test-ldap-user";
  ldapUserId = 10000;
  ldapUserPwd = "test";
  ldapGroup = "test-ldap-group";
  ldapGroupId = 10000;
  setupLdif = pkgs.writeText "test-ldap.ldif" ''
    dn: ${dbSuffix}
    dc: ${with lib; let dc = head (splitString "," dbSuffix); dcName = head (tail (splitString "=" dc)); in dcName}
    o: ${dbSuffix}
    objectclass: top
    objectclass: dcObject
    objectclass: organization

    dn: cn=${ldapUser},${dbSuffix}
    sn: ${ldapUser}
    objectClass: person
    objectClass: posixAccount
    uid: ${ldapUser}
    uidNumber: ${toString ldapUserId}
    gidNumber: ${toString ldapGroupId}
    homeDirectory: /home/${ldapUser}
    loginShell: /bin/sh
    userPassword: ${ldapUserPwd}

    dn: cn=${ldapGroup},${dbSuffix}
    objectClass: posixGroup
    gidNumber: ${toString ldapGroupId}
    memberUid: ${ldapUser}
  '';
  mkClient = useDaemon:
    { config, pkgs, lib, ... }:
    {
      virtualisation.memorySize = 256;
      virtualisation.vlans = [ 1 ];
      security.pam.services.su.rootOK = lib.mkForce false;
      users.ldap.enable = true;
      users.ldap.daemon.enable = useDaemon;
      users.ldap.loginPam = true;
      users.ldap.nsswitch = true;
      users.ldap.server = "ldap://server";
      users.ldap.base = "${dbSuffix}";
    };

in

{
  name = "ldap";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ montag451 ];
  };

  nodes = {

    server =
      { config, pkgs, lib, ... }:
      {
        virtualisation.memorySize = 256;
        virtualisation.vlans = [ 1 ];
        networking.firewall.allowedTCPPorts = [ 389 ];
        services.openldap.enable = true;
        services.openldap.dataDir = dbPath;
        services.openldap.urlList = [
          serverUri
        ];
        services.openldap.extraConfig = ''
          include ${pkgs.openldap.out}/etc/schema/core.schema
          include ${pkgs.openldap.out}/etc/schema/cosine.schema
          include ${pkgs.openldap.out}/etc/schema/inetorgperson.schema
          include ${pkgs.openldap.out}/etc/schema/nis.schema

          database mdb
          suffix ${dbSuffix}
          rootdn ${dbAdminDn}
          rootpw ${dbAdminPwd}
          directory ${dbPath}
        '';
      };

    client1 = mkClient true; # use nss_pam_ldapd
    client2 = mkClient false; # use nss_ldap and pam_ldap

  };

  testScript = ''
    startAll;
    $server->waitForUnit("default.target");
    $client1->waitForUnit("default.target");
    $client2->waitForUnit("default.target");

    $server->succeed("ldapadd -D '${dbAdminDn}' -w ${dbAdminPwd} -H ${serverUri} -f '${setupLdif}'");

    # NSS tests
    subtest "nss", sub {
        $client1->succeed("test \"\$(id -u '${ldapUser}')\" -eq ${toString ldapUserId}");
        $client1->succeed("test \"\$(id -u -n '${ldapUser}')\" = '${ldapUser}'");
        $client1->succeed("test \"\$(id -g '${ldapUser}')\" -eq ${toString ldapGroupId}");
        $client1->succeed("test \"\$(id -g -n '${ldapUser}')\" = '${ldapGroup}'");
        $client2->succeed("test \"\$(id -u '${ldapUser}')\" -eq ${toString ldapUserId}");
        $client2->succeed("test \"\$(id -u -n '${ldapUser}')\" = '${ldapUser}'");
        $client2->succeed("test \"\$(id -g '${ldapUser}')\" -eq ${toString ldapGroupId}");
        $client2->succeed("test \"\$(id -g -n '${ldapUser}')\" = '${ldapGroup}'");
    };

    # PAM tests
    subtest "pam", sub {
        $client1->succeed("echo ${ldapUserPwd} | su -l '${ldapUser}' -c true");
        $client2->succeed("echo ${ldapUserPwd} | su -l '${ldapUser}' -c true");
    };
  '';
})
