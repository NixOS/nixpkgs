import ./make-test-python.nix ({ pkgs, ... }:
let
  certs = pkgs.runCommand "cryptpadSelfSignedCerts" { buildInputs = [ pkgs.openssl ]; } ''
    mkdir -p $out
    cd $out
    openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -nodes -subj '/CN=cryptpad.localhost' -days 36500
    openssl req -x509 -newkey rsa:4096 -keyout sandbox-key.pem -out sandbox-cert.pem -nodes -subj '/CN=cryptpad-sandbox.localhost' -days 36500
  '';
  # data sniffed from cryptpad's /checkup network trace, seems to be re-usable
  test_write_data = pkgs.writeText "cryptpadTestData" ''
{"command":"WRITE_BLOCK","content":{"publicKey":"O2onvM62pC1io6jQKm8Nc2UyFXcd4kOmOsBIoYtZ2ik=","signature":"aXcM9SMO59lwA7q7HbYB+AnzymmxSyy/KhkG/cXIBVzl8v+kkPWXmFuWhcuKfRF8yt3Zc3ktIsHoFyuyDSAwAA==","ciphertext":"AFwCIfBHKdFzDKjMg4cu66qlJLpP+6Yxogbl3o9neiQou5P8h8yJB8qgnQ=="},"publicKey":"O2onvM62pC1io6jQKm8Nc2UyFXcd4kOmOsBIoYtZ2ik=","nonce":"bitSbJMNSzOsg98nEzN80a231PCkBQeH"}
  '';
  machine_config = {
    services.cryptpad = {
      enable = true;
      config = {
        httpUnsafeOrigin = "https://cryptpad.localhost";
        httpSafeOrigin = "https://cryptpad-sandbox.localhost";
      };
    };
    services.nginx = {
      enable = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      virtualHosts."cryptpad.localhost" = {
        enableACME = false;
        sslCertificate = "${certs}/cert.pem";
        sslCertificateKey = "${certs}/key.pem";
      };
      virtualHosts."cryptpad-sandbox.localhost" = {
        enableACME = false;
        sslCertificate = "${certs}/sandbox-cert.pem";
        sslCertificateKey = "${certs}/sandbox-key.pem";
      };
    };
    security = {
      pki.certificateFiles = [ "${certs}/cert.pem" "${certs}/sandbox-cert.pem" ];
    };
  };
  test_script = machine: ''
    ${machine}.wait_for_unit("cryptpad.service")
    ${machine}.wait_for_unit("nginx.service")
    ${machine}.wait_for_open_port(3000)

    # test home page
    ${machine}.succeed("curl --fail https://cryptpad.localhost -o /tmp/cryptpad_home.html")
    ${machine}.succeed("grep -F 'CryptPad: Collaboration suite' /tmp/cryptpad_home.html")
    # test npm run build actually did what it should (part of checkup)
    ${machine}.succeed("grep -F 'og:url' /tmp/cryptpad_home.html")

    # make sure child pages are accessible (e.g. check nginx try_files paths)
    ${machine}.succeed(
        "grep -oE '/(customize|components)[^\"]*' /tmp/cryptpad_home.html"
        "  | while read page; do"
        "        curl -O --fail https://cryptpad.localhost/$page || exit;"
        "    done")

    # test some API (e.g. check cryptpad main process)
    ${machine}.succeed("curl --fail -d @${test_write_data} -H 'Content-Type: application/json' https://cryptpad.localhost/api/auth")

    # test telemetry has been disabled
    ${machine}.fail("journalctl -u cryptpad | grep TELEMETRY");
  '';
in
{
  name = "cryptpad";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ martinetd ];
  };

  nodes.simple = {
    imports = [ machine_config ];
  };
  nodes.confinement = {
    imports = [ machine_config ];
    services.cryptpad.confinement = true;
  };

  testScript = ''
    start_all()
    ${test_script "simple"}
    ${test_script "confinement"}
  '';
})
