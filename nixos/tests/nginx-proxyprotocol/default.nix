let
  certs = import ./snakeoil-certs.nix;
in
import ../make-test-python.nix (
  { pkgs, ... }:
  {
    name = "nginx-proxyprotocol";

    meta = {
      maintainers = with pkgs.lib.maintainers; [ raitobezarius ];
    };

    nodes = {
      webserver =
        { pkgs, lib, ... }:
        {
          environment.systemPackages = [ pkgs.netcat ];
          security.pki.certificateFiles = [
            certs.ca.cert
          ];

          networking.extraHosts = ''
            127.0.0.5 proxy.test.nix
            127.0.0.5 noproxy.test.nix
            127.0.0.3 direct-nossl.test.nix
            127.0.0.4 unsecure-nossl.test.nix
            127.0.0.2 direct-noproxy.test.nix
            127.0.0.1 direct-proxy.test.nix
          '';
          services.nginx = {
            enable = true;
            defaultListen = [
              {
                addr = "127.0.0.1";
                proxyProtocol = true;
                ssl = true;
              }
              { addr = "127.0.0.2"; }
              {
                addr = "127.0.0.3";
                ssl = false;
              }
              {
                addr = "127.0.0.4";
                ssl = false;
                proxyProtocol = true;
              }
            ];
            commonHttpConfig = ''
              log_format pcombined '(proxy_protocol=$proxy_protocol_addr) - (remote_addr=$remote_addr) - (realip=$realip_remote_addr) - (upstream=) - (remote_user=$remote_user) [$time_local] '
                            '"$request" $status $body_bytes_sent '
                            '"$http_referer" "$http_user_agent"';
              access_log /var/log/nginx/access.log pcombined;
              error_log /var/log/nginx/error.log;
            '';
            virtualHosts =
              let
                commonConfig = {
                  locations."/".return = "200 '$remote_addr'";
                  extraConfig = ''
                    set_real_ip_from 127.0.0.5/32;
                    real_ip_header proxy_protocol;
                  '';
                };
              in
              {
                "*.test.nix" = commonConfig // {
                  sslCertificate = certs."*.test.nix".cert;
                  sslCertificateKey = certs."*.test.nix".key;
                  forceSSL = true;
                };
                "direct-nossl.test.nix" = commonConfig;
                "unsecure-nossl.test.nix" = commonConfig // {
                  extraConfig = ''
                    real_ip_header proxy_protocol;
                  '';
                };
              };
          };

          services.sniproxy = {
            enable = true;
            config = ''
              error_log {
                syslog daemon
              }
              access_log {
                syslog daemon
              }
              listener 127.0.0.5:443 {
                protocol tls
                source 127.0.0.5
              }
              table {
                ^proxy\.test\.nix$   127.0.0.1 proxy_protocol
                ^noproxy\.test\.nix$ 127.0.0.2
              }
            '';
          };
        };
    };

    testScript = ''
      def check_origin_ip(src_ip: str, dst_url: str, failure: bool = False, proxy_protocol: bool = False, expected_ip: str | None = None):
        check = webserver.fail if failure else webserver.succeed
        if expected_ip is None:
          expected_ip = src_ip

        return check(f"curl {'--haproxy-protocol' if proxy_protocol else '''} --interface {src_ip} --fail -L {dst_url} | grep '{expected_ip}'")

      webserver.wait_for_unit("nginx")
      webserver.wait_for_unit("sniproxy")
      # This should be closed by virtue of ssl = true;
      webserver.wait_for_closed_port(80, "127.0.0.1")
      # This should be open by virtue of no explicit ssl
      webserver.wait_for_open_port(80, "127.0.0.2")
      # This should be open by virtue of ssl = true;
      webserver.wait_for_open_port(443, "127.0.0.1")
      # This should be open by virtue of no explicit ssl
      webserver.wait_for_open_port(443, "127.0.0.2")
      # This should be open by sniproxy
      webserver.wait_for_open_port(443, "127.0.0.5")
      # This should be closed by sniproxy
      webserver.wait_for_closed_port(80, "127.0.0.5")

      # Sanity checks for the NGINX module
      # direct-HTTP connection to NGINX without TLS, this checks that ssl = false; works well.
      check_origin_ip("127.0.0.10", "http://direct-nossl.test.nix/")
      # webserver.execute("openssl s_client -showcerts -connect direct-noproxy.test.nix:443")
      # direct-HTTP connection to NGINX with TLS
      check_origin_ip("127.0.0.10", "http://direct-noproxy.test.nix/")
      check_origin_ip("127.0.0.10", "https://direct-noproxy.test.nix/")
      # Well, sniproxy is not listening on 80 and cannot redirect
      check_origin_ip("127.0.0.10", "http://proxy.test.nix/", failure=True)
      check_origin_ip("127.0.0.10", "http://noproxy.test.nix/", failure=True)

      # Actual PROXY protocol related tests
      # Connecting through sniproxy should passthrough the originating IP address.
      check_origin_ip("127.0.0.10", "https://proxy.test.nix/")
      # Connecting through sniproxy to a non-PROXY protocol enabled listener should not pass the originating IP address.
      check_origin_ip("127.0.0.10", "https://noproxy.test.nix/", expected_ip="127.0.0.5")

      # Attack tests against spoofing
      # Let's try to spoof our IP address by connecting direct-y to the PROXY protocol listener.
      # FIXME(RaitoBezarius): rewrite it using Python + (Scapy|something else) as this is too much broken unfortunately.
      # Or wait for upstream curl patch.
      # def generate_attacker_request(original_ip: str, target_ip: str, dst_url: str):
      #     return f"""PROXY TCP4 {original_ip} {target_ip} 80 80
      #     GET / HTTP/1.1
      #     Host: {dst_url}

      #     """
      # def spoof(original_ip: str, target_ip: str, dst_url: str, tls: bool = False, expect_failure: bool = True):
      #   method = webserver.fail if expect_failure else webserver.succeed
      #   port = 443 if tls else 80
      #   print(webserver.execute(f"cat <<EOF | nc {target_ip} {port}\n{generate_attacker_request(original_ip, target_ip, dst_url)}\nEOF"))
      #   return method(f"cat <<EOF | nc {target_ip} {port} | grep {original_ip}\n{generate_attacker_request(original_ip, target_ip, dst_url)}\nEOF")

      # check_origin_ip("127.0.0.10", "http://unsecure-nossl.test.nix", proxy_protocol=True)
      # spoof("1.1.1.1", "127.0.0.4", "direct-nossl.test.nix")
      # spoof("1.1.1.1", "127.0.0.4", "unsecure-nossl.test.nix", expect_failure=False)
    '';
  }
)
