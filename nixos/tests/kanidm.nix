import ./make-test-python.nix ({ pkgs, ... }:
  let
    certs = import ./common/acme/server/snakeoil-certs.nix;
    serverDomain = certs.domain;

    testCredentials = {
      password = "Password1_cZPEwpCWvrReripJmAZdmVIZd8HHoHcl";
    };
  in
  {
    name = "kanidm";
    meta.maintainers = with pkgs.lib.maintainers; [ erictapen Flakebi ];

    nodes.server = { config, pkgs, lib, ... }: {
      services.kanidm = {
        enableServer = true;
        serverSettings = {
          origin = "https://${serverDomain}";
          domain = serverDomain;
          bindaddress = "[::]:443";
          ldapbindaddress = "[::1]:636";
          tls_chain = certs."${serverDomain}".cert;
          tls_key = certs."${serverDomain}".key;
        };
      };

      security.pki.certificateFiles = [ certs.ca.cert ];

      networking.hosts."::1" = [ serverDomain ];
      networking.firewall.allowedTCPPorts = [ 443 ];

      users.users.kanidm.shell = pkgs.bashInteractive;

      environment.systemPackages = with pkgs; [ kanidm openldap ripgrep ];
    };

    nodes.client = { pkgs, nodes, ... }: {
      services.kanidm = {
        enableClient = true;
        clientSettings = {
          uri = "https://${serverDomain}";
          verify_ca = true;
          verify_hostnames = true;
        };
        enablePam = true;
        unixSettings = {
          pam_allowed_login_groups = [ "shell" ];
        };
      };

      networking.hosts."${nodes.server.networking.primaryIPAddress}" = [ serverDomain ];

      security.pki.certificateFiles = [ certs.ca.cert ];
    };

    testScript = { nodes, ... }:
      let
        ldapBaseDN = builtins.concatStringsSep "," (map (s: "dc=" + s) (pkgs.lib.splitString "." serverDomain));

        # We need access to the config file in the test script.
        filteredConfig = pkgs.lib.converge
          (pkgs.lib.filterAttrsRecursive (_: v: v != null))
          nodes.server.services.kanidm.serverSettings;
        serverConfigFile = (pkgs.formats.toml { }).generate "server.toml" filteredConfig;

      in
      ''
        start_all()
        server.wait_for_unit("kanidm.service")
        client.wait_for_unit("network-online.target")

        with subtest("Test HTTP interface"):
            server.wait_until_succeeds("curl -Lsf https://${serverDomain} | grep Kanidm")

        with subtest("Test LDAP interface"):
            server.succeed("ldapsearch -H ldaps://${serverDomain}:636 -b '${ldapBaseDN}' -x '(name=test)'")

        with subtest("Test CLI login"):
            client.succeed("kanidm login -D anonymous")
            client.succeed("kanidm self whoami | grep anonymous@${serverDomain}")
            client.succeed("kanidm logout")

        with subtest("Recover idm_admin account"):
            idm_admin_password = server.succeed("su - kanidm -c 'kanidmd recover-account -c ${serverConfigFile} idm_admin 2>&1 | rg -o \'[A-Za-z0-9]{48}\' '").strip().removeprefix("'").removesuffix("'")

        with subtest("Test unixd connection"):
            client.wait_for_unit("kanidm-unixd.service")
            client.wait_for_file("/run/kanidm-unixd/sock")
            client.wait_until_succeeds("kanidm-unix status | grep working!")

        with subtest("Test user creation"):
            client.wait_for_unit("getty@tty1.service")
            client.wait_until_succeeds("pgrep -f 'agetty.*tty1'")
            client.wait_until_tty_matches("1", "login: ")
            client.send_chars("root\n")
            client.send_chars("kanidm login -D idm_admin\n")
            client.wait_until_tty_matches("1", "Enter password: ")
            client.send_chars(f"{idm_admin_password}\n")
            client.wait_until_tty_matches("1", "Login Success for idm_admin")
            client.succeed("kanidm person create testuser TestUser")
            client.succeed("kanidm person posix set --shell \"$SHELL\" testuser")
            client.send_chars("kanidm person posix set-password testuser\n")
            client.wait_until_tty_matches("1", "Enter new")
            client.send_chars("${testCredentials.password}\n")
            client.wait_until_tty_matches("1", "Retype")
            client.send_chars("${testCredentials.password}\n")
            output = client.succeed("getent passwd testuser")
            assert "TestUser" in output
            client.succeed("kanidm group create shell")
            client.succeed("kanidm group posix set shell")
            client.succeed("kanidm group add-members shell testuser")

        with subtest("Test user login"):
            client.send_key("alt-f2")
            client.wait_until_succeeds("[ $(fgconsole) = 2 ]")
            client.wait_for_unit("getty@tty2.service")
            client.wait_until_succeeds("pgrep -f 'agetty.*tty2'")
            client.wait_until_tty_matches("2", "login: ")
            client.send_chars("testuser\n")
            client.wait_until_tty_matches("2", "login: testuser")
            client.wait_until_succeeds("pgrep login")
            client.wait_until_tty_matches("2", "Password: ")
            client.send_chars("${testCredentials.password}\n")
            client.wait_until_succeeds("systemctl is-active user@$(id -u testuser).service")
            client.send_chars("touch done\n")
            client.wait_for_file("/home/testuser@${serverDomain}/done")
      '';
  })
