import ../make-test-python.nix {
  name = "prosody-mysql";

  nodes = {
    client = { nodes, pkgs, ... }: {
      environment.systemPackages = [
        (pkgs.callPackage ./xmpp-sendmessage.nix { connectTo = nodes.server.config.networking.primaryIPAddress; })
      ];
      networking.extraHosts = ''
        ${nodes.server.config.networking.primaryIPAddress} example.com
        ${nodes.server.config.networking.primaryIPAddress} conference.example.com
        ${nodes.server.config.networking.primaryIPAddress} uploads.example.com
      '';
    };
    server = { config, pkgs, ... }: {
      nixpkgs.overlays = [
        (self: super: {
          prosody = super.prosody.override {
            withDBI = true;
            withExtraLibs = [ pkgs.luaPackages.luadbi-mysql ];
          };
        })
      ];
      networking.extraHosts = ''
        ${config.networking.primaryIPAddress} example.com
        ${config.networking.primaryIPAddress} conference.example.com
        ${config.networking.primaryIPAddress} uploads.example.com
      '';
      networking.firewall.enable = false;
      services.prosody = {
        enable = true;
        # TODO: use a self-signed certificate
        c2sRequireEncryption = false;
        extraConfig = ''
          storage = "sql"
          sql = {
            driver = "MySQL";
            database = "prosody";
            host = "mysql";
            port = 3306;
            username = "prosody";
            password = "password123";
          };
        '';
        virtualHosts.test = {
          domain = "example.com";
          enabled = true;
        };
        muc = [
          {
            domain = "conference.example.com";
          }
        ];
        uploadHttp = {
          domain = "uploads.example.com";
        };
      };
    };
    mysql = { config, pkgs, ... }: {
      networking.firewall.enable = false;
      services.mysql = {
        enable = true;
        initialScript = pkgs.writeText "mysql_init.sql" ''
          CREATE DATABASE prosody;
          CREATE USER 'prosody'@'server' IDENTIFIED BY 'password123';
          GRANT ALL PRIVILEGES ON prosody.* TO 'prosody'@'server';
          FLUSH PRIVILEGES;
        '';
        package = pkgs.mariadb;
      };
    };
  };

  testScript = { nodes, ... }: ''
    mysql.wait_for_unit("mysql.service")
    server.wait_for_unit("prosody.service")
    server.succeed('prosodyctl status | grep "Prosody is running"')

    # set password to 'nothunter2' (it's asked twice)
    server.succeed("yes nothunter2 | prosodyctl adduser cthon98@example.com")
    # set password to 'y'
    server.succeed("yes | prosodyctl adduser azurediamond@example.com")
    # correct password to 'hunter2'
    server.succeed("yes hunter2 | prosodyctl passwd azurediamond@example.com")

    client.succeed("send-message")

    server.succeed("prosodyctl deluser cthon98@example.com")
    server.succeed("prosodyctl deluser azurediamond@example.com")
  '';
}

