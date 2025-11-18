# SFTPGo NixOS test
#
# This NixOS test sets up a basic test scenario for the SFTPGo module
# and covers the following scenarios:
# - uploading a file via sftp
# - downloading the file over sftp
# - assert that the ACLs are respected
# - share a file between alice and bob (using sftp)
# - assert that eve cannot access the shared folder between alice and bob.
#
# Additional test coverage for the remaining protocols (i.e. ftp, http and webdav)
# would be a nice to have for the future.
{ pkgs, lib, ... }:

let
  inherit (import ./ssh-keys.nix pkgs) snakeOilPrivateKey snakeOilPublicKey;

  # Returns an attributeset of users who are not system users.
  normalUsers = config: lib.filterAttrs (name: user: user.isNormalUser) config.users.users;

  # Returns true if a user is a member of the given group
  isMemberOf =
    config:
    # str
    groupName:
    # users.users attrset
    user:
    lib.elem user.name config.users.groups.${groupName}.members;

  # Generates a valid SFTPGo user configuration for a given user
  # Will be converted to JSON and loaded on application startup.
  generateUserAttrSet =
    config:
    # attrset returned by config.users.users.<username>
    user: {
      # 0: user is disabled, login is not allowed
      # 1: user is enabled
      status = 1;

      username = user.name;
      password = ""; # disables password authentication
      public_keys = user.openssh.authorizedKeys.keys;
      email = "${user.name}@example.com";

      # User home directory on the local filesystem
      home_dir = "${config.services.sftpgo.dataDir}/users/${user.name}";

      # Defines a mapping between virtual SFTPGo paths and filesystem paths outside the user home directory.
      #
      # Supported for local filesystem only. If one or more of the specified folders are not
      # inside the dataprovider they will be automatically created.
      # You have to create the folder on the filesystem yourself
      virtual_folders = lib.optional (isMemberOf config sharedFolderName user) {
        name = sharedFolderName;
        mapped_path = "${config.services.sftpgo.dataDir}/${sharedFolderName}";
        virtual_path = "/${sharedFolderName}";
      };

      # Defines the ACL on the virtual filesystem
      permissions =
        lib.recursiveUpdate
          {
            "/" = [ "list" ]; # read-only top level directory
            "/private" = [ "*" ]; # private subdirectory, not shared with others
          }
          (
            lib.optionalAttrs (isMemberOf config "shared" user) {
              "/shared" = [ "*" ];
            }
          );

      filters = {
        allowed_ip = [ ];
        denied_ip = [ ];
        web_client = [
          "password-change-disabled"
          "password-reset-disabled"
          "api-key-auth-change-disabled"
        ];
      };

      upload_bandwidth = 0; # unlimited
      download_bandwidth = 0; # unlimited
      expiration_date = 0; # means no expiration
      max_sessions = 0;
      quota_size = 0;
      quota_files = 0;
    };

  # Generates a json file containing a static configuration
  # of users and folders to import to SFTPGo.
  loadDataJson =
    config:
    pkgs.writeText "users-and-folders.json" (
      builtins.toJSON {
        users = lib.mapAttrsToList (name: user: generateUserAttrSet config user) (normalUsers config);

        folders = [
          {
            name = sharedFolderName;
            description = "shared folder";

            # 0: local filesystem
            # 1: AWS S3 compatible
            # 2: Google Cloud Storage
            filesystem.provider = 0;

            # Mapped path on the local filesystem
            mapped_path = "${config.services.sftpgo.dataDir}/${sharedFolderName}";

            # All users in the matching group gain access
            users = config.users.groups.${sharedFolderName}.members;
          }
        ];
      }
    );

  # Generated Host Key for connecting to SFTPGo's sftp subsystem.
  snakeOilHostKey = pkgs.writeText "sftpgo_ed25519_host_key" ''
    -----BEGIN OPENSSH PRIVATE KEY-----
    b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
    QyNTUxOQAAACBOtQu6U135yxtrvUqPoozUymkjoNNPVK6rqjS936RLtQAAAJAXOMoSFzjK
    EgAAAAtzc2gtZWQyNTUxOQAAACBOtQu6U135yxtrvUqPoozUymkjoNNPVK6rqjS936RLtQ
    AAAEAoRLEV1VD80mg314ObySpfrCcUqtWoOSS3EtMPPhx08U61C7pTXfnLG2u9So+ijNTK
    aSOg009UrquqNL3fpEu1AAAADHNmdHBnb0BuaXhvcwE=
    -----END OPENSSH PRIVATE KEY-----
  '';

  adminUsername = "admin";
  adminPassword = "secretadminpassword";
  aliceUsername = "alice";
  alicePassword = "secretalicepassword";
  bobUsername = "bob";
  bobPassword = "secretbobpassword";
  eveUsername = "eve";
  evePassword = "secretevepassword";
  sharedFolderName = "shared";

  # A file for testing uploading via SFTP
  testFile = pkgs.writeText "test.txt" "hello world";
  sharedFile = pkgs.writeText "shared.txt" "shared content";

  # Define the for exposing SFTP
  sftpPort = 2022;

  # Define the for exposing HTTP
  httpPort = 8080;
in
{
  name = "sftpgo";

  meta.maintainers = with lib.maintainers; [ yayayayaka ];

  nodes = {
    server =
      { nodes, ... }:
      {
        networking.firewall.allowedTCPPorts = [
          sftpPort
          httpPort
        ];

        # nodes.server.configure postgresql database
        services.postgresql = {
          enable = true;
          ensureDatabases = [ "sftpgo" ];
          ensureUsers = [
            {
              name = "sftpgo";
              ensureDBOwnership = true;
            }
          ];
        };

        services.sftpgo = {
          enable = true;

          loadDataFile = (loadDataJson nodes.server);

          settings = {
            data_provider = {
              driver = "postgresql";
              name = "sftpgo";
              username = "sftpgo";
              host = "/run/postgresql";
              port = 5432;

              # Enables the possibility to create an initial admin user on first startup.
              create_default_admin = true;
            };

            httpd.bindings = [
              {
                address = ""; # listen on all interfaces
                port = httpPort;
                enable_https = false;

                enable_web_client = true;
                enable_web_admin = true;
              }
            ];

            # Enable sftpd
            sftpd = {
              bindings = [
                {
                  address = ""; # listen on all interfaces
                  port = sftpPort;
                }
              ];
              host_keys = [ snakeOilHostKey ];
              password_authentication = false;
              keyboard_interactive_authentication = false;
            };
          };
        };

        systemd.services.sftpgo = {
          after = [ "postgresql.target" ];
          environment = {
            # Update existing users
            SFTPGO_LOADDATA_MODE = "0";
            SFTPGO_DEFAULT_ADMIN_USERNAME = adminUsername;

            # This will end up in cleartext in the systemd service.
            # Don't use this approach in production!
            SFTPGO_DEFAULT_ADMIN_PASSWORD = adminPassword;
          };
        };

        # Sets up the folder hierarchy on the local filesystem
        systemd.tmpfiles.rules =
          let
            sftpgoUser = nodes.server.services.sftpgo.user;
            sftpgoGroup = nodes.server.services.sftpgo.group;
            statePath = nodes.server.services.sftpgo.dataDir;
          in
          [
            # Create state directory
            "d ${statePath} 0750 ${sftpgoUser} ${sftpgoGroup} -"
            "d ${statePath}/users 0750 ${sftpgoUser} ${sftpgoGroup} -"

            # Created shared folder directories
            "d ${statePath}/${sharedFolderName} 2770 ${sftpgoUser} ${sharedFolderName}   -"
          ]
          ++ lib.mapAttrsToList (
            name: user:
            # Create private user directories
            ''
              d ${statePath}/users/${user.name} 0700 ${sftpgoUser} ${sftpgoGroup} -
              d ${statePath}/users/${user.name}/private 0700 ${sftpgoUser} ${sftpgoGroup} -
            '') (normalUsers nodes.server);

        users.users =
          let
            commonAttrs = {
              isNormalUser = true;
              openssh.authorizedKeys.keys = [ snakeOilPublicKey ];
            };
          in
          {
            # SFTPGo admin user
            admin = commonAttrs // {
              password = adminPassword;
            };

            # Alice and bob share folders with each other
            alice = commonAttrs // {
              password = alicePassword;
              extraGroups = [ sharedFolderName ];
            };

            bob = commonAttrs // {
              password = bobPassword;
              extraGroups = [ sharedFolderName ];
            };

            # Eve has no shared folders
            eve = commonAttrs // {
              password = evePassword;
            };
          };

        users.groups.${sharedFolderName} = { };

        specialisation = {
          # A specialisation for asserting that SFTPGo can bind to privileged ports.
          privilegedPorts.configuration =
            { ... }:
            {
              networking.firewall.allowedTCPPorts = [
                22
                80
              ];
              services.sftpgo = {
                settings = {
                  sftpd.bindings = lib.mkForce [
                    {
                      address = "";
                      port = 22;
                    }
                  ];

                  httpd.bindings = lib.mkForce [
                    {
                      address = "";
                      port = 80;
                    }
                  ];
                };
              };
            };
        };
      };

    client =
      { nodes, ... }:
      {
        # Add the SFTPGo host key to the global known_hosts file
        programs.ssh.knownHosts =
          let
            commonAttrs = {
              publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE61C7pTXfnLG2u9So+ijNTKaSOg009UrquqNL3fpEu1";
            };
          in
          {
            "server" = commonAttrs;
            "[server]:2022" = commonAttrs;
          };
      };
  };

  testScript =
    { nodes, ... }:
    let
      # A function to generate test cases for whether
      # a specified username is expected to access the shared folder.
      accessSharedFoldersSubtest =
        {
          # The username to run as
          username,
          # Whether the tests are expected to succeed or not
          shouldSucceed ? true,
        }:
        ''
          with subtest("Test whether ${username} can access shared folders"):
              client.${
                if shouldSucceed then "succeed" else "fail"
              }("sftp -P ${toString sftpPort} -b ${pkgs.writeText "${username}-ls-${sharedFolderName}" ''
                ls ${sharedFolderName}
              ''} ${username}@server")
        '';
      statePath = nodes.server.services.sftpgo.dataDir;
    in
    ''
      start_all()

      client.wait_for_unit("default.target")
      server.wait_for_unit("sftpgo.service")

      with subtest("web client"):
          client.wait_until_succeeds("curl -sSf http://server:${toString httpPort}/web/client/login")

          # Ensure sftpgo found the static folder
          client.wait_until_succeeds("curl -o /dev/null -sSf http://server:${toString httpPort}/static/favicon.png")

      with subtest("Setup SSH keys"):
          client.succeed("mkdir -m 700 /root/.ssh")
          client.succeed("cat ${snakeOilPrivateKey} > /root/.ssh/id_ecdsa")
          client.succeed("chmod 600 /root/.ssh/id_ecdsa")

      with subtest("Copy a file over sftp"):
          client.wait_until_succeeds("scp -P ${toString sftpPort} ${toString testFile} alice@server:/private/${testFile.name}")
          server.succeed("test -s ${statePath}/users/alice/private/${testFile.name}")

          # The configured ACL should prevent uploading files to the root directory
          client.fail("scp -P ${toString sftpPort} ${toString testFile} alice@server:/")

      with subtest("Attempting an interactive SSH sessions must fail"):
          client.fail("ssh -p ${toString sftpPort} alice@server")

      ${accessSharedFoldersSubtest {
        username = "alice";
        shouldSucceed = true;
      }}

      ${accessSharedFoldersSubtest {
        username = "bob";
        shouldSucceed = true;
      }}

      ${accessSharedFoldersSubtest {
        username = "eve";
        shouldSucceed = false;
      }}

      with subtest("Test sharing files"):
          # Alice uploads a file to shared folder
          client.succeed("scp -P ${toString sftpPort} ${toString sharedFile} alice@server:/${sharedFolderName}/${sharedFile.name}")
          server.succeed("test -s ${statePath}/${sharedFolderName}/${sharedFile.name}")

          # Bob downloads the file from shared folder
          client.succeed("scp -P ${toString sftpPort} bob@server:/shared/${sharedFile.name} ${sharedFile.name}")
          client.succeed("test -s ${sharedFile.name}")

          # Eve should not get the file from shared folder
          client.fail("scp -P ${toString sftpPort} eve@server:/shared/${sharedFile.name}")

      server.succeed("/run/current-system/specialisation/privilegedPorts/bin/switch-to-configuration test")

      client.wait_until_succeeds("sftp -P 22 -b ${pkgs.writeText "get-hello-world.txt" ''
        get /private/${testFile.name}
      ''} alice@server")
    '';
}
