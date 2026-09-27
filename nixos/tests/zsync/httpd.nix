{ pkgs, lib, ... }:
let
  dir = "/var/lib/zsync-httpd";
  testFileLen = 281020;

  zsyncPkg = pkgs.zsync_0_8;

  zsync = lib.getExe zsyncPkg;
  zsyncCheck = "${zsync} --no-check-certificate";
  searchRegex = "used (\\d+) local, fetched (\\d+)";
in
{
  name = "zsync-httpd";
  meta.maintainers = [ lib.maintainers.ryand56 ];

  interactive.sshBackdoor.enable = true;

  nodes.machine = { lib, ... }: {
    virtualisation.forwardPorts = [
      {
        from = "host";
        host.port = 8081;
        guest.port = 8081;
      }
      {
        from = "host";
        host.port = 8082;
        guest.port = 8082;
      }
    ];

    networking.firewall.allowedTCPPorts = [
      8081
      8082
    ];

    systemd.services.httpd = {
      wantedBy = lib.mkForce [ ];
      after = lib.mkForce [ ];

      serviceConfig.User = lib.mkForce "root";
    };

    services.httpd = {
      enable = true;
      logDir = "${dir}/logs";

      mpm = "worker";
      extraModules = [ "http2" ];

      extraConfig = ''
        ThreadsPerChild 5
        MaxRequestWorkers 5

        Protocols h2 http/1.1

        LogFormat "%h:%{remote}p %l %u %P %t %H %{SSL_PROTOCOL}x %{SSL_CIPHER}x \"%r\" %>s %b" zsynclog

        Redirect permanent /target.dat2.zsync https://localhost:8082/target.dat.zsync
        Redirect permanent /target.dat3 https://localhost:8082/target.dat

        <AuthnProviderAlias file file1>
            AuthUserFile "${dir}/data/with-auth/passwords"
        </AuthnProviderAlias>

        <Directory ${dir}/data/>
            AuthType None
            Require all granted
        </Directory>

        <Directory ${dir}/data/with-auth/>
            AuthBasicProvider file1
            AuthType basic
            AuthName "ProtectedArea"
            Require valid-user
        </Directory>
      '';

      virtualHosts = {
        localhost = {
          listen = [
            {
              ip = "*";
              port = 8081;
            }
          ];
          documentRoot = "${dir}/data";
          extraConfig = ''
            CustomLog ${dir}/logs/access_log zsynclog
          '';
        };

        "zsync.testing" = {
          listen = [
            {
              ip = "*";
              port = 8082;
              ssl = true;
            }
          ];
          sslServerCert = "${dir}/selfsigned.crt";
          sslServerKey = "${dir}/selfsigned.key";
          documentRoot = "${dir}/data";
          extraConfig = ''
            CustomLog ${dir}/logs/access_log zsynclog
          '';
        };
      };
    };
  };

  testScript = ''
    import re

    machine.start()
    machine.succeed("udevadm settle")
    machine.wait_for_unit("multi-user.target")

    machine.succeed("mkdir -p ${dir}/data")

    machine.succeed("${lib.getExe pkgs.openssl} req -x509 -newkey rsa:2048 -keyout ${dir}/selfsigned.key -out ${dir}/selfsigned.crt -days 1 -nodes -subj /C=US/ST=Test/L=Test/O=Test/CN=zsync.testing")

    machine.succeed("systemctl restart httpd.service")

    with subtest("setup test file"):
      machine.succeed("head -c ${toString testFileLen} /dev/zero | ${lib.getExe pkgs.openssl} enc -aes-256-ctr -nosalt -pass pass:\"zsynctest\" 2>/dev/null > ${dir}/data/testfile.bin")

      machine.succeed("cp ${./testfile.bin.zsync} ${dir}/data/testfile.bin.zsync")
      machine.succeed("cp ${./testfile.bin.bad-checksum.zsync} ${dir}/data/testfile.bin.bad-checksum.zsync")

    with subtest("simple no local"):
      o = machine.succeed("${zsyncCheck} -o /tmp/output-none https://localhost:8082/testfile.bin.zsync")

      machine.succeed("cmp -s ${dir}/data/testfile.bin /tmp/output-none")

      m = re.search(r"used (\d+) local, fetched (\d+)", o)
      assert m and int(m.group(1)) == 0

    with subtest("simple all local"):
      machine.succeed("cp ${dir}/data/testfile.bin /tmp/seed")
      o = machine.succeed("${zsyncCheck} -i /tmp/seed -o /tmp/output-all https://localhost:8082/testfile.bin.zsync")

      machine.succeed("cmp -s ${dir}/data/testfile.bin /tmp/output-all")

      m = re.search(r"${searchRegex}", o)
      assert m and int(m.group(2)) == 0

      machine.succeed("rm -rf /tmp/seed")

    with subtest("simple some local"):
      machine.succeed("head -c ${toString (testFileLen / 10)} ${dir}/data/testfile.bin | dd of=/tmp/seed bs=1M count=${toString (testFileLen / 5)}")
      machine.succeed("head -c ${toString (testFileLen / 3)} ${dir}/data/testfile.bin | dd of=/tmp/seed bs=1M count=${toString (testFileLen / 3)}")

      o = machine.succeed("${zsyncCheck} -i /tmp/seed -o /tmp/output-some https://localhost:8082/testfile.bin.zsync")

      machine.succeed("cmp -s ${dir}/data/testfile.bin /tmp/output-some")

      m = re.search(r"${searchRegex}", o)
      assert m and int(m.group(1)) >= 0 and int(m.group(2)) >= 0

    with subtest("bad checksum"):
      machine.succeed("echo abcd > /tmp/bad-checksum")
      o = machine.fail("${zsyncCheck} https://localhost:8082/testfile.bin.bad-checksum.zsync 2>&1")

      assert "checksum mismatch" in o

      machine.succeed("ls /tmp/bad-checksum")
      size = int(machine.succeed("stat -c%s /tmp/bad-checksum"))

      assert size == 5
  '';
}
