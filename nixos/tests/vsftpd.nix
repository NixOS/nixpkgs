import ./make-test-python.nix ({ pkgs, ... }: {
  name = "vsftpd";

  nodes = {
    server = {
      services.vsftpd = {
        enable = true;
        userlistDeny = false;
        localUsers = true;
        userlist = [ "ftp-test-user" ];
        writeEnable = true;
        localRoot = "/tmp";
      };
      networking.firewall.enable = false;

      users = {
        users.ftp-test-user = {
          isSystemUser = true;
          password = "ftp-test-password";
          group = "ftp-test-group";
        };
        groups.ftp-test-group = {};
      };
    };

    client = {};
  };

  testScript = ''
    client.start()
    server.wait_for_unit("vsftpd")
    server.wait_for_open_port(21)

    client.succeed("curl -u ftp-test-user:ftp-test-password ftp://server")
    client.succeed('echo "this is a test" > /tmp/test.file.up')
    client.succeed("curl -v -T /tmp/test.file.up -u ftp-test-user:ftp-test-password ftp://server")
    client.succeed("curl -u ftp-test-user:ftp-test-password ftp://server/test.file.up > /tmp/test.file.down")
    client.succeed("diff /tmp/test.file.up /tmp/test.file.down")
    assert client.succeed("cat /tmp/test.file.up") == server.succeed("cat /tmp/test.file.up")
    assert client.succeed("cat /tmp/test.file.down") == server.succeed("cat /tmp/test.file.up")
  '';
})
