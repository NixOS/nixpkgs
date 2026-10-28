{ lib, ... }:
let
  cellName = "cell.com";
  realmName = lib.toUpper cellName;
in
{
  name = "openafs";
  defaults =
    { config, nodes, ... }:
    let
      cellServDB = {
        ${cellName} = lib.mapAttrsToList (_: config: {
          ip = config.networking.primaryIPAddress;
          dnsname = "${config.networking.hostName}.${config.networking.domain}";
        }) nodes;
      };
    in
    {
      config = {
        virtualisation.vlans = [ 1 ];
        networking.useDHCP = false; # Disable external connectivity
        networking.domain = cellName;
        networking.firewall.enable = false;

        security.krb5 = {
          enable = true;
          settings.libdefaults.default_realm = realmName;
        };
        services.openafsClient = {
          enable = true;
          inherit cellName;
          cellServDB = cellServDB // {
            "grand.central.org" = [
              {
                ip = "1.1.1.1";
                dnsname = "one.grand.central.org";
              }
            ];
          };
        };
        services.openafsServer = {
          enable = true;
          inherit cellName cellServDB;
        };
        security.krb5.settings.realms.${realmName} = {
          admin_server = nodes.a.networking.primaryIPAddress;
          kdc = [ nodes.a.networking.primaryIPAddress ];
        };
      };
    };
  nodes.a = {
    services.kerberos_server = {
      enable = true;
      settings.realms."CELL.COM".acl = [
        {
          principal = "admin";
          access = [
            "add"
            "cpw"
          ];
        }
      ];
    };
  };
  nodes.b = { };

  testScript = ''
    import re

    def setup_kdc(machine):
      # Set up realm
      machine.succeed(
        "kdb5_util create -s -r CELL.COM -P master_key",
        "systemctl restart kadmind.service kdc.service",
      )
      for unit in ["kadmind", "kdc"]:
        machine.wait_for_unit(f"{unit}.service")
      # Create admin and afs/ principals
      machine.succeed(
        "kadmin.local add_principal -randkey admin",
        "rm -f /tmp/shared/admin.keytab",
        "kadmin.local ktadd -k /tmp/shared/admin.keytab admin",
        "kadmin.local add_principal -randkey -e aes256-cts-hmac-sha1-96:normal,aes128-cts-hmac-sha1-96:normal afs/${cellName}",
      )
      # Generate a keytab for afs/
      out = machine.succeed(
        "rm -f /tmp/shared/rxkad.keytab",
        "kadmin.local ktadd -k /tmp/shared/rxkad.keytab -e aes256-cts-hmac-sha1-96:normal,aes128-cts-hmac-sha1-96:normal afs/${cellName}",
      )
      m = re.search(r"kvno (\d+)", out)
      assert m
      kvno = m.group(1)
      return kvno

    def setup_afs_daemons(machine, kvno):
      machine.succeed(
        "mkdir -p /vicepa",
        "touch /vicepa/AlwaysAttach",
      )
      machine.succeed(*(
        f"asetkey add rxkad_krb5 {kvno} {enctype} /tmp/shared/rxkad.keytab afs/${cellName}"
        for enctype in (18, 17)
      ))
      machine.start_job("openafs-server")
      machine.wait_until_succeeds("bos adduser localhost admin -localauth")

    start_all()
    kvno = setup_kdc(a)
    setup_afs_daemons(a, kvno)
    setup_afs_daemons(b, kvno)
    # Create initial 'admin' user
    # N.B. It can take 60+ seconds before the ptserver has quorum and accepts writes, so try a few times until it succeeds
    a.wait_until_succeeds("pts createuser -name admin -localauth")
    a.succeed(
      "pts adduser admin system:administrators -localauth",
    )
    # Create initial volumes
    a.wait_until_succeeds("vos listvol localhost -localauth")
    a.succeed(
      "vos create localhost vicepa root.afs -localauth",
      "vos create localhost vicepa root.cell -localauth",
    )
    # Authenticate and add a file
    a.succeed(
      "kinit -k -t /tmp/shared/admin.keytab admin",
      "aklog",
      "echo pass > /afs/${cellName}/test.txt",
    )
    # Authenticate and read a file
    b.succeed(
      "kinit -k -t /tmp/shared/admin.keytab admin",
      "aklog",
    )
    assert b.succeed("cat /afs/${cellName}/test.txt").strip() == "pass"

    # Ensure the global CellServDB can be overridden.
    assert a.succeed("fs listcells -n | grep grand.central.org").strip() == "Cell grand.central.org on hosts 1.1.1.1."
  '';
}
