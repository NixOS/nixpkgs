import ./make-test-python.nix ({ pkgs, lib, ... }:
  let
    tls-cert = pkgs.runCommand "selfSignedCerts" {
      buildInputs = [ pkgs.openssl ];
    } ''
      mkdir -p $out
      openssl req -x509 \
        -subj '/CN=localhost/' -days 365 \
        -addext 'subjectAltName = DNS:localhost' \
        -keyout "$out/cert.key" -newkey ed25519 \
        -out "$out/cert.pem" -noenc
    '';
  in {
    name = "filebrowser";
    meta.maintainers = with lib.maintainers; [ christoph-heiss ];

    nodes = {
      http = {
        services.filebrowser = {
          enable = true;
        };
      };
      https  = {
        security.pki.certificateFiles = [ "${tls-cert}/cert.pem" ];
        services.filebrowser = {
          enable = true;
          tlsCertificate = "${tls-cert}/cert.pem";
          tlsCertificateKey = "${tls-cert}/cert.key";
        };
      };
    };

    testScript = ''
      start_all()

      with subtest("check if http works"):
        http.wait_for_unit("filebrowser.service")
        http.wait_for_open_port(8080)
        http.succeed("curl -sSf http://localhost:8080 | grep '<!doctype html>'")

      with subtest("check if https works"):
        https.wait_for_unit("filebrowser.service")
        https.wait_for_open_port(8080)
        https.succeed("curl -sSf https://localhost:8080 | grep '<!doctype html>'")
    '';
  })
