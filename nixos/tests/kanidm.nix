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
          bindaddress = "[::1]:8443";
          ldapbindaddress = "[::1]:636";
        };
      };

      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        virtualHosts."${serverDomain}" = {
          forceSSL = true;
          sslCertificate = certs."${serverDomain}".cert;
          sslCertificateKey = certs."${serverDomain}".key;
          locations."/".proxyPass = "http://[::1]:8443";
        };
      };

      security.pki.certificateFiles = [ certs.ca.cert ];

      networking.hosts."::1" = [ serverDomain ];
      networking.firewall.allowedTCPPorts = [ 80 443 ];

      users.users.kanidm.shell = pkgs.bashInteractive;

      environment.systemPackages = with pkgs; [ kanidm openldap ripgrep ];
    };

    nodes.client = { pkgs, nodes, ... }: {
      services.kanidm = {
        enableClient = true;
        clientSettings = {
          uri = "https://${serverDomain}";
        };
      };

      networking.hosts."${nodes.server.config.networking.primaryIPAddress}" = [ serverDomain ];

      security.pki.certificateFiles = [ certs.ca.cert ];
    };

    testScript = { nodes, ... }:
      let
        ldapBaseDN = builtins.concatStringsSep "," (map (s: "dc=" + s) (pkgs.lib.splitString "." serverDomain));

        # We need access to the config file in the test script.
        filteredConfig = pkgs.lib.converge
          (pkgs.lib.filterAttrsRecursive (_: v: v != null))
          nodes.server.config.services.kanidm.serverSettings;
        serverConfigFile = (pkgs.formats.toml { }).generate "server.toml" filteredConfig;

      in
      ''
        start_all()
        server.wait_for_unit("kanidm.service")
        server.wait_until_succeeds("curl -sf https://${serverDomain} | grep Kanidm")
        server.wait_until_succeeds("ldapsearch -H ldap://[::1]:636 -b '${ldapBaseDN}' -x '(name=test)'")
        client.wait_until_succeeds("kanidm login -D anonymous && kanidm self whoami | grep anonymous@${serverDomain}")
        (rv, result) = server.execute("kanidmd recover_account -d quiet -c ${serverConfigFile} -n admin 2>&1 | rg -o '[A-Za-z0-9]{48}'")
        assert rv == 0
      '';
  })
