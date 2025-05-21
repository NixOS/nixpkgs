{ lib, hostPkgs, ... }:
{
  name = "haproxy";
  nodes = {
    server =
      { pkgs, ... }:
      {
        services.haproxy = {
          enable = true;
          config = ''
            global
              limited-quic

            defaults
              mode http
              timeout connect 10s
              timeout client 10s
              timeout server 10s

              log /dev/log local0 debug err
              option logasap
              option httplog
              option httpslog

            backend http_server
              server httpd [::1]:8000 alpn http/1.1

            frontend http
              bind :80
              bind :443 ssl strict-sni crt /etc/ssl/fullchain.pem alpn h2,http/1.1
              bind quic4@:443 ssl strict-sni crt /etc/ssl/fullchain.pem alpn h3 allow-0rtt

              http-after-response add-header alt-svc 'h3=":443"; ma=60' if { ssl_fc }

              http-request use-service prometheus-exporter if { path /metrics }
              use_backend http_server

            frontend http-cert-auth
              bind :8443 ssl strict-sni crt /etc/ssl/fullchain.pem verify required ca-file /etc/ssl/cacert.crt
              bind quic4@:8443 ssl strict-sni crt /etc/ssl/fullchain.pem verify required ca-file /etc/ssl/cacert.crt alpn h3

              use_backend http_server
          '';
        };
        services.httpd = {
          enable = true;
          virtualHosts.localhost = {
            documentRoot = pkgs.writeTextDir "index.txt" "We are all good!";
            adminAddr = "notme@yourhost.local";
            listen = [
              {
                ip = "::1";
                port = 8000;
              }
            ];
          };
        };
        networking.firewall.allowedTCPPorts = [
          80
          443
          8443
        ];
        networking.firewall.allowedUDPPorts = [
          443
          8443
        ];
      };
    client =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.curlHTTP3 ];
      };
  };
  testScript = ''
    # Helpers
    def cmd(command):
      print(f"+{command}")
      r = os.system(command)
      if r != 0:
        raise Exception(f"Command {command} failed with exit code {r}")

    def openssl(command):
      cmd(f"${lib.getExe hostPkgs.openssl} {command}")

    # Generate CA.
    openssl("req -new -newkey rsa:4096 -nodes -x509 -days 7 -subj '/C=ZZ/ST=Cloud/L=Unspecified/O=NixOS/OU=Tests/CN=CA Certificate' -keyout cacert.key -out cacert.crt")

    # Generate and sign Server.
    openssl("req -newkey rsa:4096 -nodes -subj '/CN=server/OU=Tests/O=NixOS' -keyout server.key -out server.csr")
    openssl("x509 -req -in server.csr -out server.crt -CA cacert.crt -CAkey cacert.key -days 7")
    cmd("cat server.crt server.key > fullchain.pem")

    # Generate and sign Client.
    openssl("req -newkey rsa:4096 -nodes -subj '/CN=client/OU=Tests/O=NixOS' -keyout client.key -out client.csr")
    openssl("x509 -req -in client.csr -out client.crt -CA cacert.crt -CAkey cacert.key -days 7")
    cmd("cat client.crt client.key > client.pem")

    # Start the actual test.
    start_all()
    server.copy_from_host("fullchain.pem", "/etc/ssl/fullchain.pem")
    server.copy_from_host("cacert.crt", "/etc/ssl/cacert.crt")
    server.succeed("chmod 0644 /etc/ssl/fullchain.pem /etc/ssl/cacert.crt")

    client.copy_from_host("cacert.crt", "/etc/ssl/cacert.crt")
    client.copy_from_host("client.pem", "/root/client.pem")

    server.wait_for_unit("multi-user.target")
    server.wait_for_unit("haproxy.service")
    server.wait_for_unit("httpd.service")

    assert "We are all good!" in client.succeed("curl -f http://server/index.txt")
    assert "haproxy_process_pool_allocated_bytes" in client.succeed("curl -f http://server/metrics")

    with subtest("https"):
      assert "We are all good!" in client.succeed("curl -f --cacert /etc/ssl/cacert.crt https://server/index.txt")

    with subtest("https-cert-auth"):
      # Client must succeed in authenticating with the right certificate.
      assert "We are all good!" in client.succeed("curl -f --cacert /etc/ssl/cacert.crt --cert-type pem --cert /root/client.pem https://server:8443/index.txt")
      # Client must fail without certificate.
      client.fail("curl --cacert /etc/ssl/cacert.crt https://server:8443/index.txt")

    with subtest("h3"):
      assert "We are all good!" in client.succeed("curl -f --http3-only --cacert /etc/ssl/cacert.crt https://server/index.txt")

    with subtest("h3-cert-auth"):
      # Client must succeed in authenticating with the right certificate.
      assert "We are all good!" in client.succeed("curl -f --http3-only --cacert /etc/ssl/cacert.crt --cert-type pem --cert /root/client.pem https://server:8443/index.txt")
      # Client must fail without certificate.
      client.fail("curl -f --http3-only --cacert /etc/ssl/cacert.crt https://server:8443/index.txt")

    with subtest("reload"):
        server.succeed("systemctl reload haproxy")
        # wait some time to ensure the following request hits the reloaded haproxy
        server.sleep(5)
        assert "We are all good!" in client.succeed("curl -f http://server/index.txt")
  '';
}
