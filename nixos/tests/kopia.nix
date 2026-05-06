{ pkgs, ... }:
let
  passwordFile = "${pkgs.writeText "kopia-password" "test-password"}";
  webPasswordFile = "${pkgs.writeText "kopia-web-password" "test-web-pass"}";
  s3AccessKeyIdFile = "${pkgs.writeText "s3-access-key-id" "minioadmin"}";
  s3SecretAccessKeyFile = "${pkgs.writeText "s3-secret-access-key" "minioadmin"}";
  webdavUsernameFile = "${pkgs.writeText "webdav-username" "kopia"}";
  webdavPasswordFile = "${pkgs.writeText "webdav-password" "kopia-webdav-pass"}";
  sftpPasswordFile = "${pkgs.writeText "sftp-password" "kopia-sftp-pass"}";

  testDir = pkgs.stdenvNoCC.mkDerivation {
    name = "test-files-to-backup";
    unpackPhase = "true";
    installPhase = ''
      mkdir $out
      echo some_file > $out/some_file
      echo some_other_file > $out/some_other_file
      mkdir $out/a_dir
      echo a_file > $out/a_dir/a_file
    '';
  };

  kopiaEnv =
    name: "KOPIA_CONFIG_PATH=/var/lib/kopia/${name}/repository.config KOPIA_PASSWORD=test-password";
in
{
  name = "kopia";

  meta.maintainers = [ ];

  nodes.server =
    { pkgs, ... }:
    {
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = true;
          PermitRootLogin = "no";
        };
      };
      users.users.kopia = {
        isNormalUser = true;
        password = "kopia-sftp-pass";
        home = "/home/kopia";
        createHome = true;
      };

      services.minio = {
        enable = true;
        rootCredentialsFile = pkgs.writeText "minio-credentials" ''
          MINIO_ROOT_USER=minioadmin
          MINIO_ROOT_PASSWORD=minioadmin
        '';
      };

      # Open MinIO and WebDAV ports
      networking.firewall.allowedTCPPorts = [
        8080
        9000
      ];

      systemd.services.nginx.serviceConfig.ReadWritePaths = [ "/var/lib/webdav" ];

      services.nginx = {
        enable = true;
        additionalModules = [ pkgs.nginxModules.dav ];
        virtualHosts."webdav" = {
          listen = [
            {
              addr = "0.0.0.0";
              port = 8080;
            }
          ];
          locations."/" = {
            extraConfig = ''
              dav_methods PUT DELETE MKCOL COPY MOVE;
              dav_ext_methods PROPFIND OPTIONS;
              dav_access user:rw group:rw all:r;
              create_full_put_path on;
              autoindex on;
              root /var/lib/webdav;
              auth_basic "WebDAV";
              auth_basic_user_file /etc/nginx/htpasswd;
            '';
          };
        };
      };
    };

  nodes.machine =
    { pkgs, ... }:
    {
      services.kopia.backups = {
        # Test: filesystem backend basic
        filesystem-basic = {
          repository.filesystem.path = "/var/lib/kopia-repo";
          inherit passwordFile;
          paths = [ "/opt" ];
          timerConfig = null;
        };

        # Test: filesystem with policy
        with-policy = {
          repository.filesystem.path = "/var/lib/kopia-repo-policy";
          inherit passwordFile;
          paths = [ "/opt" ];
          timerConfig = null;
          policy.retention.keep-daily = 3;
          policy.compression = "zstd";
        };

        # Test: web UI
        with-web = {
          repository.filesystem.path = "/var/lib/kopia-repo-web";
          inherit passwordFile;
          paths = [ "/opt" ];
          timerConfig = null;
          web.enable = true;
          web.serverPasswordFile = webPasswordFile;
        };

        # Test: backup hooks
        with-hooks = {
          repository.filesystem.path = "/var/lib/kopia-repo-hooks";
          inherit passwordFile;
          paths = [ "/opt" ];
          timerConfig = null;
          backupPrepareCommand = "#!/bin/sh\ntouch /var/lib/kopia/with-hooks/prepare-ran";
          backupCleanupCommand = "#!/bin/sh\ntouch /var/lib/kopia/with-hooks/cleanup-ran";
        };

        # Test: SFTP backend with password file
        sftp-basic = {
          repository.sftp = {
            host = "server";
            path = "/home/kopia/repo";
            username = "kopia";
            passwordFile = sftpPasswordFile;
            knownHostsFile = "/root/.ssh/known_hosts";
          };
          inherit passwordFile;
          paths = [ "/opt" ];
          timerConfig = null;
        };

        # Test: SFTP backend with file-based password
        sftp-password-file = {
          repository.sftp = {
            host = "server";
            path = "/home/kopia/repo-file";
            username = "kopia";
            passwordFile = sftpPasswordFile;
            knownHostsFile = "/root/.ssh/known_hosts";
          };
          inherit passwordFile;
          paths = [ "/opt" ];
          timerConfig = null;
        };

        # Test: WebDAV backend with password file
        webdav-basic = {
          repository.webdav = {
            url = "http://server:8080/";
            username = "kopia";
            passwordFile = webdavPasswordFile;
          };
          inherit passwordFile;
          paths = [ "/opt" ];
          timerConfig = null;
        };

        # Test: WebDAV backend with file-based credentials
        webdav-file-creds = {
          repository.webdav = {
            url = "http://server:8080/file-creds/";
            usernameFile = webdavUsernameFile;
            passwordFile = webdavPasswordFile;
          };
          inherit passwordFile;
          paths = [ "/opt" ];
          timerConfig = null;
        };

        # Test: S3 backend with file-based credentials (via MinIO)
        s3-basic = {
          repository.s3 = {
            bucket = "kopia-test";
            endpoint = "server:9000";
            accessKeyIdFile = s3AccessKeyIdFile;
            secretAccessKeyFile = s3SecretAccessKeyFile;
            disableTLS = true;
          };
          inherit passwordFile;
          paths = [ "/opt" ];
          timerConfig = null;
        };

        # Test: timer (uses default timerConfig)
        with-timer = {
          repository.filesystem.path = "/var/lib/kopia-repo-timer";
          inherit passwordFile;
          paths = [ "/opt" ];
        };

        # Test: extra snapshot args
        with-extra-args = {
          repository.filesystem.path = "/var/lib/kopia-repo-extra-args";
          inherit passwordFile;
          paths = [ "/opt" ];
          timerConfig = null;
          extraSnapshotArgs = [
            "--parallel=1"
            "--description=test-snapshot"
          ];
        };

        # Test: expanded policy options
        with-expanded-policy = {
          repository.filesystem.path = "/var/lib/kopia-repo-expanded-policy";
          inherit passwordFile;
          paths = [ "/opt" ];
          timerConfig = null;
          policy = {
            retention = {
              keep-daily = 7;
              keep-weekly = 4;
              keep-monthly = 6;
            };
            compression = "zstd";
            files = {
              ignore = [
                "*.tmp"
                "*.log"
              ];
              ignore-cache-dirs = true;
            };
            errorHandling = {
              ignore-file-errors = true;
              ignore-dir-errors = true;
            };
          };
        };

        # Test: custom web port
        with-web-custom-port = {
          repository.filesystem.path = "/var/lib/kopia-repo-web-custom";
          inherit passwordFile;
          paths = [ "/opt" ];
          timerConfig = null;
          web = {
            enable = true;
            address = "127.0.0.1:9999";
            serverPasswordFile = webPasswordFile;
          };
        };
      };

      environment.systemPackages = [
        pkgs.jq
        pkgs.curl
        pkgs.kopia
      ];
    };

  testScript = ''
    server.start()
    machine.start()
    server.wait_for_unit("default.target")
    machine.wait_for_unit("default.target")

    # Setup test data
    machine.succeed("cp -rT ${testDir} /opt")

    with subtest("service-properties: verify hardening on snapshot service"):
        machine.succeed(
            "systemctl show -p Nice --value kopia-snapshot-filesystem-basic.service"
            " | grep -q '^19$'"
        )
        machine.succeed(
            "systemctl show -p ProtectSystem --value kopia-snapshot-filesystem-basic.service"
            " | grep -q 'strict'"
        )
        machine.succeed(
            "systemctl show -p NoNewPrivileges --value kopia-snapshot-filesystem-basic.service"
            " | grep -q 'yes'"
        )

    with subtest("with-timer: timer unit is active"):
        machine.require_unit_state("kopia-snapshot-with-timer.timer", "active")

    with subtest("filesystem-basic: repository connect and snapshot"):
        machine.succeed("mkdir -p /var/lib/kopia-repo")
        machine.succeed("systemctl start kopia-repository-filesystem-basic.service")
        machine.succeed("systemctl start kopia-snapshot-filesystem-basic.service")
        machine.succeed(
            "${kopiaEnv "filesystem-basic"}"
            " kopia snapshot list /opt --json | jq -e 'length == 1'"
        )

    with subtest("sftp-basic: repository connect and snapshot over SFTP"):
        server.wait_for_unit("sshd.service")
        # Populate known_hosts on machine from server's host key
        machine.succeed(
            "mkdir -p /root/.ssh && ssh-keyscan server > /root/.ssh/known_hosts 2>/dev/null"
        )
        # Create repo directory on server
        server.succeed("mkdir -p /home/kopia/repo && chown kopia:users /home/kopia/repo")
        machine.succeed("systemctl start kopia-repository-sftp-basic.service")
        machine.succeed("systemctl start kopia-snapshot-sftp-basic.service")
        machine.succeed(
            "${kopiaEnv "sftp-basic"}"
            " kopia snapshot list /opt --json | jq -e 'length == 1'"
        )

    with subtest("sftp-password-file: repository connect with file-based password"):
        server.succeed("mkdir -p /home/kopia/repo-file && chown kopia:users /home/kopia/repo-file")
        machine.succeed("systemctl start kopia-repository-sftp-password-file.service")
        machine.succeed("systemctl start kopia-snapshot-sftp-password-file.service")
        machine.succeed(
            "${kopiaEnv "sftp-password-file"}"
            " kopia snapshot list /opt --json | jq -e 'length == 1'"
        )

    with subtest("webdav-basic: repository connect and snapshot over WebDAV"):
        # Set up nginx WebDAV with basic auth on server
        server.succeed(
            "mkdir -p /var/lib/webdav /etc/nginx"
        )
        server.succeed(
            "${pkgs.apacheHttpd}/bin/htpasswd -bc /etc/nginx/htpasswd kopia kopia-webdav-pass"
        )
        server.succeed("chown nginx:nginx /var/lib/webdav")
        server.succeed("systemctl restart nginx")
        server.wait_for_open_port(8080)
        machine.succeed("systemctl start kopia-repository-webdav-basic.service")
        machine.succeed("systemctl start kopia-snapshot-webdav-basic.service")
        machine.succeed(
            "${kopiaEnv "webdav-basic"}"
            " kopia snapshot list /opt --json | jq -e 'length == 1'"
        )

    with subtest("webdav-file-creds: repository connect with file-based credentials"):
        machine.succeed("systemctl start kopia-repository-webdav-file-creds.service")
        machine.succeed("systemctl start kopia-snapshot-webdav-file-creds.service")
        machine.succeed(
            "${kopiaEnv "webdav-file-creds"}"
            " kopia snapshot list /opt --json | jq -e 'length == 1'"
        )

    with subtest("s3-basic: repository connect and snapshot over S3 (file-based credentials)"):
        server.wait_for_unit("minio.service")
        server.wait_for_open_port(9000)
        # Create buckets using MinIO client
        server.succeed(
            "${pkgs.minio-client}/bin/mc alias set local http://localhost:9000 minioadmin minioadmin"
        )
        server.succeed("${pkgs.minio-client}/bin/mc mb local/kopia-test")
        machine.succeed("systemctl start kopia-repository-s3-basic.service")
        machine.succeed("systemctl start kopia-snapshot-s3-basic.service")
        machine.succeed(
            "${kopiaEnv "s3-basic"}"
            " kopia snapshot list /opt --json | jq -e 'length == 1'"
        )

    with subtest("with-hooks: prepare and cleanup commands execute"):
        machine.succeed("mkdir -p /var/lib/kopia-repo-hooks")
        machine.succeed("systemctl start kopia-repository-with-hooks.service")
        machine.succeed("systemctl start kopia-snapshot-with-hooks.service")
        machine.succeed("test -e /var/lib/kopia/with-hooks/prepare-ran")
        machine.succeed("test -e /var/lib/kopia/with-hooks/cleanup-ran")
        machine.succeed(
            "${kopiaEnv "with-hooks"}"
            " kopia snapshot list /opt --json | jq -e 'length == 1'"
        )

    with subtest("with-extra-args: extra snapshot args applied"):
        machine.succeed("mkdir -p /var/lib/kopia-repo-extra-args")
        machine.succeed("systemctl start kopia-repository-with-extra-args.service")
        machine.succeed("systemctl start kopia-snapshot-with-extra-args.service")
        machine.succeed(
            "${kopiaEnv "with-extra-args"}"
            " kopia snapshot list /opt --json | jq -e 'length == 1'"
        )
        machine.succeed(
            "${kopiaEnv "with-extra-args"}"
            " kopia snapshot list /opt --json"
            " | jq -e '.[0].description == \"test-snapshot\"'"
        )

    with subtest("with-policy: retention and compression"):
        machine.succeed("mkdir -p /var/lib/kopia-repo-policy")
        machine.succeed("systemctl start kopia-repository-with-policy.service")
        machine.succeed("systemctl start kopia-policy-with-policy.service")
        machine.succeed(
            "${kopiaEnv "with-policy"}"
            " kopia policy show /opt --json"
            " | jq -e '.retention.keepDaily == 3'"
        )
        machine.succeed(
            "${kopiaEnv "with-policy"}"
            " kopia policy show /opt --json"
            " | jq -e '.compression.compressorName == \"zstd\"'"
        )
        machine.succeed("systemctl start kopia-snapshot-with-policy.service")
        machine.succeed(
            "${kopiaEnv "with-policy"}"
            " kopia snapshot list /opt --json | jq -e 'length == 1'"
        )

    with subtest("with-expanded-policy: retention, files, error handling"):
        machine.succeed("mkdir -p /var/lib/kopia-repo-expanded-policy")
        machine.succeed("systemctl start kopia-repository-with-expanded-policy.service")
        machine.succeed("systemctl start kopia-policy-with-expanded-policy.service")
        machine.succeed(
            "${kopiaEnv "with-expanded-policy"}"
            " kopia policy show /opt --json"
            " | jq -e '.retention.keepDaily == 7'"
        )
        machine.succeed(
            "${kopiaEnv "with-expanded-policy"}"
            " kopia policy show /opt --json"
            " | jq -e '.retention.keepWeekly == 4'"
        )
        machine.succeed(
            "${kopiaEnv "with-expanded-policy"}"
            " kopia policy show /opt --json"
            " | jq -e '.retention.keepMonthly == 6'"
        )
        machine.succeed(
            "${kopiaEnv "with-expanded-policy"}"
            " kopia policy show /opt --json"
            " | jq -e '.compression.compressorName == \"zstd\"'"
        )

    with subtest("with-web: web UI responds with 401"):
        machine.succeed("mkdir -p /var/lib/kopia-repo-web")
        machine.succeed("systemctl start kopia-repository-with-web.service")
        machine.succeed("systemctl start kopia-web-with-web.service")
        machine.wait_for_open_port(51515)
        machine.succeed(
            "curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:51515/"
            " | grep -q '401'"
        )

    with subtest("with-web-custom-port: web UI on port 9999"):
        machine.succeed("mkdir -p /var/lib/kopia-repo-web-custom")
        machine.succeed("systemctl start kopia-repository-with-web-custom-port.service")
        machine.succeed("systemctl start kopia-web-with-web-custom-port.service")
        machine.wait_for_open_port(9999)
        machine.succeed(
            "curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:9999/"
            " | grep -q '401'"
        )
  '';
}
