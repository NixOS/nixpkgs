import ../make-test-python.nix ({ pkgs, lib, ... }:

let
  security.krb5 = {
    enable = true;
    settings = {
      domain_realm."nfs.test" = "NFS.TEST";
      libdefaults.default_realm = "NFS.TEST";
      realms."NFS.TEST" = {
        admin_server = "server.nfs.test";
        kdc = "server.nfs.test";
      };
    };
  };

  hosts =
    ''
      192.168.1.1 client.nfs.test
      192.168.1.2 server.nfs.test
    '';

  users = {
    users.alice = {
        isNormalUser = true;
        name = "alice";
        uid = 1000;
      };
  };

in

{
  name = "nfsv4-with-kerberos";

  nodes = {
    client = { lib, ... }:
      { inherit security users;

        networking.extraHosts = hosts;
        networking.domain = "nfs.test";
        networking.hostName = "client";

        virtualisation.fileSystems =
          { "/data" = {
              device  = "server.nfs.test:/";
              fsType  = "nfs";
              options = [ "nfsvers=4" "sec=krb5p" "noauto" ];
            };
          };
      };

    server = { lib, ...}:
      { inherit security users;

        networking.extraHosts = hosts;
        networking.domain = "nfs.test";
        networking.hostName = "server";

        networking.firewall.allowedTCPPorts = [
          111  # rpc
          2049 # nfs
          88   # kerberos
          749  # kerberos admin
        ];

        services.kerberos_server.enable = true;
        services.kerberos_server.realms =
          { "NFS.TEST".acl =
            [ { access = "all"; principal = "admin/admin"; } ];
          };

        services.nfs.server.enable = true;
        services.nfs.server.createMountPoints = true;
        services.nfs.server.exports =
          ''
            /data *(rw,no_root_squash,fsid=0,sec=krb5p)
          '';
      };
  };

  testScript =
    ''
      server.succeed("mkdir -p /data/alice")
      server.succeed("chown alice:users /data/alice")

      # set up kerberos database
      server.succeed(
          "kdb5_util create -s -r NFS.TEST -P master_key",
          "systemctl restart kadmind.service kdc.service",
      )
      server.wait_for_unit("kadmind.service")
      server.wait_for_unit("kdc.service")

      # create principals
      server.succeed(
          "kadmin.local add_principal -randkey nfs/server.nfs.test",
          "kadmin.local add_principal -randkey nfs/client.nfs.test",
          "kadmin.local add_principal -pw admin_pw admin/admin",
          "kadmin.local add_principal -pw alice_pw alice",
      )

      # add principals to server keytab
      server.succeed("kadmin.local ktadd nfs/server.nfs.test")
      server.succeed("systemctl start rpc-gssd.service rpc-svcgssd.service")
      server.wait_for_unit("rpc-gssd.service")
      server.wait_for_unit("rpc-svcgssd.service")

      client.systemctl("start network-online.target")
      client.wait_for_unit("network-online.target")

      # add principals to client keytab
      client.succeed("echo admin_pw | kadmin -p admin/admin ktadd nfs/client.nfs.test")
      client.succeed("systemctl start rpc-gssd.service")
      client.wait_for_unit("rpc-gssd.service")

      with subtest("nfs share mounts"):
          client.succeed("systemctl restart data.mount")
          client.wait_for_unit("data.mount")

      with subtest("permissions on nfs share are enforced"):
          client.fail("su alice -c 'ls /data'")
          client.succeed("su alice -c 'echo alice_pw | kinit'")
          client.succeed("su alice -c 'ls /data'")

          client.fail("su alice -c 'echo bla >> /data/foo'")
          client.succeed("su alice -c 'echo bla >> /data/alice/foo'")
          server.succeed("test -e /data/alice/foo")

      with subtest("uids/gids are mapped correctly on nfs share"):
          ids = client.succeed("stat -c '%U %G' /data/alice").split()
          expected = ["alice", "users"]
          assert ids == expected, f"ids incorrect: got {ids} expected {expected}"
    '';

  meta.maintainers = [ lib.maintainers.dblsaiko ];
})
