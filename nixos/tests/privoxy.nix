import ./make-test-python.nix ({ lib, pkgs, ... }:

let
  # Note: For some reason Privoxy can't issue valid
  # certificates if the CA is generated using gnutls :(
  certs = pkgs.runCommand "example-certs"
    { buildInputs = [ pkgs.openssl ]; }
    ''
      mkdir $out

      # generate CA keypair
      openssl req -new -nodes -x509 \
        -extensions v3_ca -keyout $out/ca.key \
        -out $out/ca.crt -days 365 \
        -subj "/O=Privoxy CA/CN=Privoxy CA"

      # generate server key/signing request
      openssl genrsa -out $out/server.key 3072
      openssl req -new -key $out/server.key \
        -out server.csr -sha256 \
        -subj "/O=An unhappy server./CN=example.com"

      # sign the request/generate the certificate
      openssl x509 -req -in server.csr -CA $out/ca.crt \
      -CAkey $out/ca.key -CAcreateserial -out $out/server.crt \
      -days 500 -sha256
    '';
in

{
  name = "privoxy";
  meta = with lib.maintainers; {
    maintainers = [ rnhmjoj ];
  };

  nodes.machine = { ... }: {
    services.nginx.enable = true;
    services.nginx.virtualHosts."example.com" = {
      addSSL = true;
      sslCertificate = "${certs}/server.crt";
      sslCertificateKey = "${certs}/server.key";
      locations."/".root = pkgs.writeTextFile
        { name = "bad-day";
          destination = "/how-are-you/index.html";
          text = "I've had a bad day!\n";
        };
      locations."/ads".extraConfig = ''
        return 200 "Hot Nixpkgs PRs in your area. Click here!\n";
      '';
    };

    services.privoxy = {
      enable = true;
      inspectHttps = true;
      settings = {
        ca-cert-file = "${certs}/ca.crt";
        ca-key-file  = "${certs}/ca.key";
        debug = 65536;
      };
      userActions = ''
        {+filter{positive}}
        example.com

        {+block{Fake ads}}
        example.com/ads
      '';
      userFilters = ''
        FILTER: positive This is a filter example.
        s/bad/great/ig
      '';
    };

    security.pki.certificateFiles = [ "${certs}/ca.crt" ];

    networking.hosts."::1" = [ "example.com" ];
    networking.proxy.httpProxy = "http://localhost:8118";
    networking.proxy.httpsProxy = "http://localhost:8118";
  };

  testScript =
    ''
      with subtest("Privoxy is running"):
          machine.wait_for_unit("privoxy")
          machine.wait_for_open_port(8118)
          machine.succeed("curl -f http://config.privoxy.org")

      with subtest("Privoxy can filter http requests"):
          machine.wait_for_open_port(80)
          assert "great day" in machine.succeed(
              "curl -sfL http://example.com/how-are-you? | tee /dev/stderr"
          )

      with subtest("Privoxy can filter https requests"):
          machine.wait_for_open_port(443)
          assert "great day" in machine.succeed(
              "curl -sfL https://example.com/how-are-you? | tee /dev/stderr"
          )

      with subtest("Blocks are working"):
          machine.wait_for_open_port(443)
          machine.fail("curl -f https://example.com/ads 1>&2")
          machine.succeed("curl -f https://example.com/PRIVOXY-FORCE/ads 1>&2")

      with subtest("Temporary certificates are cleaned"):
          # Count current certificates
          machine.succeed("test $(ls /run/privoxy/certs | wc -l) -gt 0")
          # Forward in time 12 days, trigger the timer..
          machine.succeed("date -s \"$(date --date '12 days')\"")
          machine.systemctl("start systemd-tmpfiles-clean")
          # ...and count again
          machine.succeed("test $(ls /run/privoxy/certs | wc -l) -eq 0")
    '';
})
