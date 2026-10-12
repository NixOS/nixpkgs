{ pkgs, lib, ... }:
let
  tls-cert = pkgs.runCommand "selfSignedCerts" { buildInputs = [ pkgs.openssl ]; } ''
    openssl req \
      -x509 -newkey rsa:4096 -sha256 -days 365 \
      -nodes -out cert.pem -keyout key.pem \
      -subj '/CN=headscale' -addext "subjectAltName=DNS:headscale"

    mkdir -p $out
    cp key.pem cert.pem $out
  '';
  headscalePort = 8080;
  stunPort = 3478;
in
{
  name = "hydrascale";
  meta.maintainers = with lib.maintainers; [ sophronesis ];

  nodes = {
    headscale = {
      services = {
        headscale = {
          enable = true;
          port = headscalePort;
          settings = {
            server_url = "https://headscale";
            derp = {
              server = {
                enabled = true;
                region_id = 999;
                stun_listen_addr = "0.0.0.0:${toString stunPort}";
              };
              urls = [ ];
            };
            dns = {
              base_domain = "tailnet";
              override_local_dns = false;
            };
          };
        };
        nginx = {
          enable = true;
          virtualHosts.headscale = {
            addSSL = true;
            sslCertificate = "${tls-cert}/cert.pem";
            sslCertificateKey = "${tls-cert}/key.pem";
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

    # a plain tailscale node on the headscale tailnet
    peer = {
      services.tailscale.enable = true;
      security.pki.certificateFiles = [ "${tls-cert}/cert.pem" ];
    };

    # joins the same tailnet from inside a hydrascale network namespace
    machine = {
      security.pki.certificateFiles = [ "${tls-cert}/cert.pem" ];
      services.hydrascale = {
        enable = true;
        settings = {
          tailnets = [
            {
              id = "hs";
              control_url = "https://headscale";
              host_access = true;
            }
          ];
          access = {
            # the "internet" target excludes RFC 1918 ranges, so enforce mode
            # would block the namespace from the headscale node on the test LAN
            mode = "observe";
            rules = [
              {
                from = "hs";
                to = "internet";
              }
              {
                from = "host";
                to = "hs";
              }
            ];
          };
        };
      };
    };
  };

  testScript = ''
    start_all()
    headscale.wait_for_unit("headscale")
    headscale.wait_for_open_port(443)

    headscale.succeed("headscale users create test")
    authkey = headscale.succeed("headscale preauthkeys -u 1 create --reusable").strip()

    peer.wait_for_unit("tailscaled")
    peer.execute(f"tailscale up --login-server 'https://headscale' --auth-key {authkey}")

    machine.wait_for_unit("hydrascale")
    machine.wait_until_succeeds("ip netns list | grep -q ns-hs")
    machine.wait_until_succeeds("${lib.getExe pkgs.curl} -fsS http://127.0.0.1:9443/ >/dev/null")
    machine.wait_until_succeeds(
      f"hydrascale tailscale hs -- up --login-server 'https://headscale' --auth-key {authkey}"
    )
    machine.wait_until_succeeds("hydrascale tailscale hs -- ip -4")

    # host access: the host reaches the peer over the namespaced tailscaled
    peer_ip = peer.wait_until_succeeds("tailscale ip -4").strip()
    machine.wait_until_succeeds(f"ping -c1 -W2 {peer_ip}")
    peer.wait_until_succeeds("tailscale ping machine")
  '';
}
