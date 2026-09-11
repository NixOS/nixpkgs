{
  config,
  lib,
  pkgs,
  ...
}:
let
  domain = "example.test";
in
{
  # Caddy only supports useACMEHost, hence we use a distinct test suite
  name = "caddy";
  meta = {
    maintainers = lib.teams.acme.members;
    # Hard timeout in seconds. Average run time is about 60 seconds.
    timeout = 180;
  };

  nodes = {
    # The fake ACME server which will respond to client requests
    acme =
      { nodes, ... }:
      {
        imports = [ ../common/acme/server ];
      };

    caddy =
      { nodes, config, ... }:
      let
        fqdn = config.networking.fqdn;
      in
      {
        imports = [ ../common/acme/client ];
        networking.domain = domain;
        networking.firewall.allowedTCPPorts = [
          80
          443
        ];

        # Resolve the vhosts the easy way
        networking.hosts."127.0.0.1" = [
          "caddy-alt.${domain}"
        ];

        # OpenSSL will be used for more thorough certificate validation
        environment.systemPackages = [ pkgs.openssl ];

        security.acme.certs."${fqdn}" = {
          listenHTTP = ":8080";
          reloadServices = [ "caddy.service" ];
        };

        users.users."${config.services.caddy.user}".extraGroups = [ "acme" ];

        services.caddy = {
          enable = true;
          # FIXME reloading caddy is not sufficient to load new certs.
          # Restart it manually until this is fixed.
          enableReload = false;
          globalConfig = ''
            auto_https off
          '';
          virtualHosts."${fqdn}:443" = {
            useACMEHost = fqdn;
          };
          virtualHosts.":80".extraConfig = ''
            reverse_proxy localhost:8080
          '';
        };

        specialisation.add_domain.configuration = {
          security.acme.certs.${fqdn}.extraDomainNames = [
            "caddy-alt.${domain}"
          ];
        };
      };
  };

  testScript =
    { nodes, ... }:
    ''
      ${(import ./utils.nix).pythonUtils}

      domain = "${domain}"
      ca_domain = "${nodes.acme.test-support.acme.caDomain}"
      fqdn = "${nodes.caddy.networking.fqdn}"

      with subtest("Boot and start with selfsigned certificates"):
          caddy.start()
          caddy.wait_for_unit("caddy.service")
          check_issuer(caddy, fqdn, "minica")
          # Check that the web server has picked up the selfsigned cert
          check_connection(caddy, fqdn, minica=True)

      acme.start()
      wait_for_running(acme)
      acme.wait_for_open_port(443)

      with subtest("Acquire a new cert"):
          caddy.succeed(f"systemctl restart acme-{fqdn}.service")
          check_issuer(caddy, fqdn, "pebble")
          check_domain(caddy, fqdn, fqdn)
          download_ca_certs(caddy, ca_domain)
          check_connection(caddy, fqdn)

      with subtest("security.acme changes reflect on caddy"):
          check_connection(caddy, f"caddy-alt.{domain}", fail=True)
          switch_to(caddy, "add_domain")
          check_connection(caddy, f"caddy-alt.{domain}")
    '';
}
