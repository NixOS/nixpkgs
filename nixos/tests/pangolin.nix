{
  lib,
  pkgs,
  ...
}:
let
  # cant use .test, since that gets caught by traefik
  domain = "nixos.eu";
  secret = "1234567890";

  dnsServerIP = nodes: nodes.dnsserver.networking.primaryIPAddress;

in
{
  name = "pangolin";
  meta.maintainers = with lib.maintainers; [
    jackr
    sigmasquadron
  ];

  # The full test is not yet implemented, but once upstream supports a way to
  # configure Pangolin non-interactively, the full test will look like the following:
  # - 'acme': ACME server to replace the real servers at Let's Encrypt.
  # - 'dnsserver': The pebble challenge test server so we can use a private DNS
  #                for everything here.
  # - 'VPS': The Pangolin instance, running Gerbil, Traefik, and Badger as well.
  # - 'privateHost': The private server running an HTTP server on its local
  #                  network that will be tunnelled via Newt to the VPS.
  # - 'client': An outside node that will test if the service hosted in
  #             'privateHost' is publicly accessible.
  # TODO: In the future, we should also have a machine to test the
  #       functionality of Olm, as well as a split Pangolin/Gerbil
  #       configuration once that is implemented into the module.
  nodes = {
    acme =
      { nodes, ... }:
      {
        imports = [ ./common/acme/server ];
        networking.nameservers = lib.mkForce [ (dnsServerIP nodes) ];
      };

    dnsserver =
      { nodes, ... }:
      {
        networking = {
          firewall.allowedTCPPorts = [
            8055
            53
          ];
          firewall.allowedUDPPorts = [ 53 ];

          # nixos/lib/testing/network.nix will provide name resolution via /etc/hosts
          # for all nodes based on their host names and domain
          hostName = "dnsserver";
          domain = "eu";
        };
        systemd.services.pebble-challtestsrv = {
          description = "Pebble ACME challenge test server";
          wantedBy = [ "network.target" ];
          serviceConfig = {
            ExecStart = "${lib.getExe' pkgs.pebble "pebble-challtestsrv"} -dns01 ':53' -defaultIPv6 '' -defaultIPv4 '${nodes.VPS.networking.primaryIPAddress}'";
            # Required to bind on privileged ports.
            AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
          };
        };
      };

    VPS =
      { nodes, ... }:
      {
        imports = [ ./common/acme/client ];
        networking = {
          inherit domain;
          hosts.${nodes.VPS.networking.primaryIPAddress} = [
            domain
            "pangolin.${domain}"
          ];
          nameservers = lib.mkForce [ (dnsServerIP nodes) ];
        };

        environment = {
          etc = {
            "nixos/secrets/pangolin.env".text = ''
              SERVER_SECRET=${secret}
            '';
          };
        };

        services = {
          pangolin = {
            enable = true;
            baseDomain = domain;
            letsEncryptEmail = "pangolin@${domain}";
            openFirewall = true;
            environmentFile = "/etc/nixos/secrets/pangolin.env";
            settings = {
              flags.enable_integration_api = true;
            };
          };
          # set up local ca server, so we can get our certs signed without going on the internet
          traefik.staticConfigOptions.certificatesResolvers.letsencrypt.acme.caServer =
            lib.mkForce "https://${nodes.acme.test-support.acme.caDomain}/dir";
        };
      };

  };
  testScript = ''
    ${(import ./acme/utils.nix).pythonUtils}

    with subtest("start ACME and DNS server"):
      acme.start()
      wait_for_running(acme)
      acme.wait_for_open_port(443)
      dnsserver.start()
      dnsserver.wait_for_open_port(53)

    VPS.start()

    with subtest("start Pangolin"):
      VPS.wait_for_unit("pangolin.service")
      VPS.wait_for_open_port(3000)
      VPS.wait_for_open_port(3001)
      VPS.wait_for_open_port(3002)
      VPS.wait_for_open_port(3003)

    with subtest("start Gerbil"):
      VPS.wait_for_unit("gerbil.service")

    with subtest("start Traefik"):
      VPS.wait_for_unit("traefik.service")
      VPS.wait_for_open_port(80)
      VPS.wait_for_open_port(443)

    with subtest("check traefik certs}"):
      download_ca_certs(VPS, "acme.test")

  '';
}
