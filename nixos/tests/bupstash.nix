import ./make-test-python.nix (
  { pkgs, lib, ... }:

  let
    keys = {
      main = pkgs.writeText "main.key" ''
        # This file contains a cryptographic key used by 'bupstash' to encrypt and decrypt data.
        #
        # key-id=267dfddda37c7b08edb6e67489b2a70f

        -----BEGIN BUPSTASH KEY-----
        ACZ9/d2jfHsI7bbmdImypw9dJjmfr8wwB3BZ4a9qN/vR85qO3SNWCYERfF0/2+qc
        bjou2C31eCyrTPxCTlEgeuXwncgwX1szbCfKfN5bhcKglayjULVXS+I3qrcyyuQ4
        4lC6kN2+8SKZBUP+sVREhbSRC3CoUXMBqSIhF2PCgqO3I8yquyP+wmnUVyIHVQUH
        dqKiDJ2WxjJuDXe5CBXnkG+HqlY5XvTc5+CZivW+h+7jHlCIvfqFskzXNm9gDyf+
        X9vC/AxeQe2+cPsHs0zsKMR/UQ3Qz90zRFALJzsI3TtNSK88H6w0/8UbqBfUyb9r
        Qy8ghUEE6zw8mM8ub1+vfmPLz/R6D/JC5GSqnF5SVxSXuYke1u0L4DOxkDB4SayX
        GAWrz7cDLCiEDE3ZcODSlHpSvFyKSmu4iT+EvXoIAeaMzFq73I1nQoMkBPWmUcKP
        3k8iCe+1GvFO42icMlDbvtRl9cJdSxOSXNrpZd7XiJX/2Gl6tK2G+g/DUAWu08W/
        DyzXlrkI0YS7Bvp7C027WV7aOYQhIZbPC0fnSqr+B155O/L7oJ9lhg4LsGW02has
        YQ7UMvDiIvmbdcbQ0T1juxF2F4zvv5ftklTOCDqfQAL/
        -----END BUPSTASH KEY-----
      '';

      put = pkgs.writeText "put.key" ''
        # This file contains a cryptographic key used by 'bupstash' to encrypt and decrypt data.
        #
        # key-id=c8afdddfc1bddb1b1f3e0c318237a857
        # derived-from-key-id=267dfddda37c7b08edb6e67489b2a70f
        # is-put-key=true
        # is-list-key=false
        # is-list-contents-key=false

        -----BEGIN BUPSTASH SUB KEY-----
        Aciv3d/BvdsbHz4MMYI3qFcmff3do3x7CO225nSJsqcPAT8Tqt0hvUt5BJcY/Hpf
        twNmfYzeE7yDsDPr8/TIdgdUATou2C31eCyrTPxCTlEgeuXwncgwX1szbCfKfN5b
        hcKgAZjczSVPqdmkwkLBRDkKdcRTpPZOPMyDOjqljTjENlFaAZELcKhRcwGpIiEX
        Y8KCo7cjzKq7I/7CadRXIgdVBQd2AAEeUIi9+oWyTNc2b2APJ/5f28L8DF5B7b5w
        +wezTOwoxAF/UQ3Qz90zRFALJzsI3TtNSK88H6w0/8UbqBfUyb9rQwGQ/OEiQ3i+
        6phzBfuUP3Ks4vBp5m/kWM3B7DVCvKvtagG5iR7W7QvgM7GQMHhJrJcYBavPtwMs
        KIQMTdlw4NKUegABTyIJ77Ua8U7jaJwyUNu+1GX1wl1LE5Jc2ull3teIlf8B2Gl6
        tK2G+g/DUAWu08W/DyzXlrkI0YS7Bvp7C027WV4AAQ7UMvDiIvmbdcbQ0T1juxF2
        F4zvv5ftklTOCDqfQAL/
        -----END BUPSTASH SUB KEY-----
      '';

      list = pkgs.writeText "main.key" ''
        # This file contains a cryptographic key used by 'bupstash' to encrypt and decrypt data.
        #
        # key-id=2c1ec4b64f53485ddc9643fc9c637085
        # derived-from-key-id=267dfddda37c7b08edb6e67489b2a70f
        # is-put-key=false
        # is-list-key=true
        # is-list-contents-key=true

        -----BEGIN BUPSTASH SUB KEY-----
        ASwexLZPU0hd3JZD/JxjcIUmff3do3x7CO225nSJsqcPAAAAAAAAAX9RDdDP3TNE
        UAsnOwjdO01IrzwfrDT/xRuoF9TJv2tDAAG5iR7W7QvgM7GQMHhJrJcYBavPtwMs
        KIQMTdlw4NKUegFSvFyKSmu4iT+EvXoIAeaMzFq73I1nQoMkBPWmUcKP3gFPIgnv
        tRrxTuNonDJQ277UZfXCXUsTklza6WXe14iV/wHYaXq0rYb6D8NQBa7Txb8PLNeW
        uQjRhLsG+nsLTbtZXgHaOYQhIZbPC0fnSqr+B155O/L7oJ9lhg4LsGW02hasYQEO
        1DLw4iL5m3XG0NE9Y7sRdheM77+X7ZJUzgg6n0AC/w==
        -----END BUPSTASH SUB KEY-----
      '';
    };

    dataDir = "/root/data";
    excludeFile = "not_this_file";
    keepFile = "important_file";
    keepFileData = "important_data";

    privateKey = pkgs.writeText "id_ed25519" ''
      -----BEGIN OPENSSH PRIVATE KEY-----
      b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
      QyNTUxOQAAACBx8UB04Q6Q/fwDFjakHq904PYFzG9pU2TJ9KXpaPMcrwAAAJB+cF5HfnBe
      RwAAAAtzc2gtZWQyNTUxOQAAACBx8UB04Q6Q/fwDFjakHq904PYFzG9pU2TJ9KXpaPMcrw
      AAAEBN75NsJZSpt63faCuaD75Unko0JjlSDxMhYHAPJk2/xXHxQHThDpD9/AMWNqQer3Tg
      9gXMb2lTZMn0pelo8xyvAAAADXJzY2h1ZXR6QGt1cnQ=
      -----END OPENSSH PRIVATE KEY-----
    '';

    publicKey = ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHHxQHThDpD9/AMWNqQer3Tg9gXMb2lTZMn0pelo8xyv root@client
    '';
  in
  {
    name = "bupstash";
    meta.maintainers = with lib.maintainers; [ thubrecht ];

    nodes = {
      server = {
        services.bupstash.repositories = {
          enable = true;
          access = [
            {
              repo = "default";
              keys = [ publicKey ];
            }
          ];
        };

        services.openssh = {
          enable = true;
          settings = {
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
          };
        };
      };

      client = {
        services.bupstash.jobs = {
          default = {
            startAt = "*-*-* 00:00:00";
            paths = [ dataDir ];
            excludes = [ excludeFile ];
            key = keys.put;
            user = "bupstash";

            repositories = {
              remote = {
                command = "ssh -i /root/id_ed25519 -oStrictHostKeyChecking=no bupstash-repo@server";
                createRepository = true;
              };

              local.uri = "/bupstash/backup";
            };
          };
        };

        users.users.bupstash = {
          isSystemUser = true;
          home = "/bupstash";
          group = "bupstash";
          createHome = true;
        };
        users.groups.bupstash = { };

        environment.systemPackages = [ pkgs.bupstash ];
      };
    };

    testScript = ''
      start_all()

      command = "ssh -i /root/id_ed25519 -oStrictHostKeyChecking=no bupstash-repo@server"

      # Copy the required files to the data directory
      client.succeed("mkdir -p ${dataDir}")
      client.succeed("touch ${dataDir}/${excludeFile}")
      client.succeed("echo '${keepFileData}' > ${dataDir}/${keepFile}")

      client.fail("test -d '/backup'")

      # Copy the ssh key with the correct permissions
      client.succeed("cp ${privateKey} /root/id_ed25519")
      client.succeed("chmod 0600 /root/id_ed25519")

      # Create the local repository
      client.succeed("${lib.getExe pkgs.bupstash} init -r /bupstash/backup")
      client.succeed("chown -R bupstash:bupstash /bupstash/backup")

      # Wait until the server is up
      server.wait_for_unit("sshd.service")

      # Start the backup
      client.systemctl("start bupstash-default.target")

      # Check that the jobs succedeed
      client.fail("systemctl is-failed bupstash-default-command-remote.service")
      client.fail("systemctl is-failed bupstash-default-uri-local.service")

      # Check that the data is in the local repo
      s = client.succeed("bupstash list-contents -r /bupstash/backup -k ${keys.list} name=default")

      assert "${keepFile}" in s
      assert "${excludeFile}" not in s

      data = client.succeed("bupstash get --pick=${keepFile} -r /bupstash/backup -k ${keys.main} name=default")
      assert "${keepFileData}\n" == data

      # Check that the data is in the remote repo
      s = client.succeed(f"BUPSTASH_REPOSITORY_COMMAND='{command}' bupstash list-contents -k ${keys.list} name=default")

      assert "${keepFile}" in s
      assert "${excludeFile}" not in s

      data = client.succeed(f"BUPSTASH_REPOSITORY_COMMAND='{command}' bupstash get --pick=${keepFile} -k ${keys.main} name=default")
      assert "${keepFileData}\n" == data
    '';
  }
)
