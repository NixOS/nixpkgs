import ./make-test-python.nix (
  { pkgs, lib, ... }:
  let
    certs = import ./common/acme/server/snakeoil-certs.nix;
  in
  {
    name = "headscale";
    meta.maintainers = with lib.maintainers; [
      kradalby
      misterio77
    ];

    nodes =
      let
        headscalePort = 8080;
        stunPort = 3478;
        peer = {
          networking.hosts."192.168.1.1" = [ certs.domain ];
          services.tailscale.enable = true;
          security.pki.certificateFiles = [ certs.${certs.domain}.cert ];
        };
      in
      {
        peer1 = peer;
        peer2 = peer;

        headscale = {
          services = {
            headscale = {
              enable = true;
              port = headscalePort;
              settings = {
                server_url = "https://${certs.domain}";
                ip_prefixes = [ "100.64.0.0/10" ];
                derp.server = {
                  enabled = true;
                  region_id = 999;
                  stun_listen_addr = "0.0.0.0:${toString stunPort}";
                };
                dns.base_domain = "tailnet";
              };
            };
            nginx = {
              enable = true;
              virtualHosts.${certs.domain} = {
                addSSL = true;
                sslCertificate = certs.${certs.domain}.cert;
                sslCertificateKey = certs.${certs.domain}.key;
                locations."/" = {
                  proxyPass = "http://127.0.0.1:${toString headscalePort}";
                  proxyWebsockets = true;
                };
              };
            };
          };
          networking.firewall = {
            allowedTCPPorts = [
              80
              443
            ];
            allowedUDPPorts = [ stunPort ];
          };
          environment.systemPackages = [ pkgs.headscale ];
        };
      };

    testScript = ''
      start_all()
      headscale.wait_for_unit("headscale")
      headscale.wait_for_open_port(443)

      # Create headscale user and preauth-key
      headscale.succeed("headscale users create test")
      authkey = headscale.succeed("headscale preauthkeys -u test create --reusable")

      # Connect peers
      up_cmd = f"tailscale up --login-server 'https://${certs.domain}' --auth-key {authkey}"
      peer1.execute(up_cmd)
      peer2.execute(up_cmd)

      # Check that they are reachable from the tailnet
      peer1.wait_until_succeeds("tailscale ping peer2")
      peer2.wait_until_succeeds("tailscale ping peer1.tailnet")
    '';
  }
)
