import ./make-test-python.nix ({ pkgs, ... }:
  let
    certs = import ./common/acme/server/snakeoil-certs.nix;
    serverDomain = certs.domain;
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

        with subtest("Test HTTP interface"):
            server.wait_until_succeeds("curl -sf https://${serverDomain} | grep Kanidm")

        with subtest("Test LDAP interface"):
            server.succeed("ldapsearch -H ldaps://${serverDomain}:636 -b '${ldapBaseDN}' -x '(name=test)'")

        with subtest("Test CLI login"):
            client.succeed("kanidm login -D anonymous")
            client.succeed("kanidm self whoami | grep anonymous@${serverDomain}")

        with subtest("Recover idm_admin account"):
            # Must stop the server for account recovery or else kanidmd fails with
            # "unable to lock kanidm exclusive lock at /var/lib/kanidm/kanidm.db.klock".
            server.succeed("systemctl stop kanidm")
            server.succeed("su - kanidm -c 'kanidmd recover-account -c ${serverConfigFile} idm_admin 2>&1 | rg -o \'[A-Za-z0-9]{48}\' '")
            server.succeed("systemctl start kanidm")

        with subtest("Test unixd connection"):
            client.wait_for_unit("kanidm-unixd.service")
            # TODO: client.wait_for_file("/run/kanidm-unixd/sock")
            client.wait_until_succeeds("kanidm-unix status | grep working!")
      '';
  })
