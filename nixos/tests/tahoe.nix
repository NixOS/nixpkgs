import ./make-test-python.nix ({ pkgs, ... }:
  let
    # A keypair for the SFTP server the test configures.
    pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEfea58DJYClV0yPF8+pIhu+krRdzM26q93tyR1FGmuW";
    privKey = ''
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACBH3mufAyWApVdMjxfPqSIbvpK0XczNuqvd7ckdRRprlgAAAJhwfTnXcH05
1wAAAAtzc2gtZWQyNTUxOQAAACBH3mufAyWApVdMjxfPqSIbvpK0XczNuqvd7ckdRRprlg
AAAEAlaJKga3OdxlERbdaCBRLotKsHQ0wr1MCb6tIIatZSPUfea58DJYClV0yPF8+pIhu+
krRdzM26q93tyR1FGmuWAAAADmV4YXJrdW5AbWFnbm9uAQIDBAUGBw==
-----END OPENSSH PRIVATE KEY-----
'';
    sftpdAccountsFile = pkgs.writeText "sftpd.accounts" "someuser ${pubKey} URI:DIR2:aaaa...";
    hostPrivateKeyFile = pkgs.writeText "hostkey" privKey;
    hostPublicKeyFile = pkgs.writeText "hostkey.pub" pubKey;
  in
{
  name = "tahoe";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ exarkun ];
  };

  nodes.machine =
    { ... }:
    { services.tahoe.nodes.some_storage = {
        # Set all of the options that are individually handled.
        nickname = "some-storage";
        tub.port = 12345;
        tub.location = "tcp:127.0.0.1:12345";
        web.port = 4321;

        client.introducer = "pb://aaaa@bbbb/cccc";
        client.helper = "pb://dddd@eeee/ffff";
        client.shares.needed = 5;
        client.shares.happy = 6;
        client.shares.total = 7;

        helper.enable = true;

        sftpd.enable = true;
        sftpd.port = 5678;
        sftpd.hostPublicKeyFile = hostPublicKeyFile;
        sftpd.hostPrivateKeyFile = hostPrivateKeyFile;
        sftpd.accounts.file = sftpdAccountsFile;

        # Set some other stuff using the freeform settings support.
        settings.storage = {
          enabled = true;
          reserved_space = "2G";
          "expire.enabled" = "true";
          "expire.mode" = "age";
          "expire.override_lease_duration" = "1day";
        };
      };
    };

  testScript = ''
    def check_section(cfg, section_name, expected):
        actual = sorted(cfg.items(section_name))
        expected = sorted(expected)
        print(f"  actual: {actual!r}")
        print(f"expected: {expected!r}")
        assert actual == expected, f"{section_name} section differed from expectation"

    start_all()

    machine.wait_for_unit("tahoe.node-some_storage.service")

    # The various ports we configured should be open.
    for port in [12345, 4321, 5678]:
        machine.wait_for_open_port(port)

    from configparser import ConfigParser
    cfg = machine.succeed("cat /var/db/tahoe-lafs/node-some_storage/tahoe.cfg")
    p = ConfigParser()
    p.read_string(cfg)

    with subtest("node section"):
        expected = {
            ("nickname", "some-storage"),
            ("tub.port", "12345"),
            ("tub.location", "tcp:127.0.0.1:12345"),
            ("web.port", "tcp:4321"),
        }
        check_section(p, "node", expected)

    with subtest("client section"):
        expected = {
            ("introducer.furl", "pb://aaaa@bbbb/cccc"),
            ("helper.furl", "pb://dddd@eeee/ffff"),
            ("shares.needed", "5"),
            ("shares.happy", "6"),
            ("shares.total", "7"),
        }
        check_section(p, "client", expected)

    with subtest("helper section"):
        expected = {
            ("enabled", "true"),
        }
        check_section(p, "helper", expected)

    with subtest("storage section"):
        expected = {
            ("enabled", "true"),
            ("expire.enabled", "true"),
            ("expire.mode", "age"),
            ("expire.override_lease_duration", "1day"),
            ("reserved_space", "2G"),
        }
        check_section(p, "storage", expected)

    with subtest("sftpd section"):
        expected = {
            ("enabled", "true"),
            ("host_pubkey_file", "${hostPublicKeyFile}"),
            ("host_privkey_file", "${hostPrivateKeyFile}"),
            ("accounts.file", "${sftpdAccountsFile}"),
            ("port", "tcp:5678"),
        }
        check_section(p, "sftpd", expected)
  '';
})
