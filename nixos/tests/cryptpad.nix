{ lib, pkgs, ... }:
let
  certs = pkgs.runCommand "cryptpadSelfSignedCerts" { buildInputs = [ pkgs.openssl ]; } ''
    mkdir -p $out
    cd $out
    openssl req -x509 -newkey rsa:4096 \
      -keyout key.pem -out cert.pem -nodes -days 3650 \
      -subj '/CN=cryptpad.localhost' \
      -addext 'subjectAltName = DNS.1:cryptpad.localhost, DNS.2:cryptpad-sandbox.localhost'
  '';
  # data sniffed from cryptpad's /checkup network trace, seems to be re-usable
  test_write_data = pkgs.writeText "cryptpadTestData" ''
    {"command":"WRITE_BLOCK","content":{"publicKey":"O2onvM62pC1io6jQKm8Nc2UyFXcd4kOmOsBIoYtZ2ik=","signature":"aXcM9SMO59lwA7q7HbYB+AnzymmxSyy/KhkG/cXIBVzl8v+kkPWXmFuWhcuKfRF8yt3Zc3ktIsHoFyuyDSAwAA==","ciphertext":"AFwCIfBHKdFzDKjMg4cu66qlJLpP+6Yxogbl3o9neiQou5P8h8yJB8qgnQ=="},"publicKey":"O2onvM62pC1io6jQKm8Nc2UyFXcd4kOmOsBIoYtZ2ik=","nonce":"bitSbJMNSzOsg98nEzN80a231PCkBQeH"}
  '';
  seleniumScript =
    pkgs.writers.writePython3Bin "selenium-script"
      {
        libraries = with pkgs.python3Packages; [ selenium ];
      }
      ''
        from sys import stderr
        from time import time
        from selenium import webdriver
        from selenium.webdriver.common.by import By
        from selenium.webdriver.firefox.options import Options
        from selenium.webdriver.support.ui import WebDriverWait
        from selenium.webdriver.support import expected_conditions as EC

        options = Options()
        options.add_argument("--headless")
        service = webdriver.FirefoxService(executable_path="${lib.getExe pkgs.geckodriver}")  # noqa: E501

        driver = webdriver.Firefox(options=options, service=service)
        driver.implicitly_wait(10)
        driver.get("https://cryptpad.localhost")

        WebDriverWait(driver, 10).until(
          EC.text_to_be_present_in_element(
            (By.TAG_NAME, "body"), "CryptPad")
        )

        driver.find_element(By.PARTIAL_LINK_TEXT, "Sheet").click()

        # Title changes once the sheet is rendered, which can take
        # a lot of time on first run (browser generates keypair etc)
        start = time()
        WebDriverWait(driver, 60).until(
          EC.title_contains('Sheet')
        )
        print(f"Sheets done loading in {time() - start}", file=stderr)

        # check screen looks sane...
        # driver.print_page() and dump pdf somewhere through pdftotext? OCR?

        driver.close()
      '';
in
{
  name = "cryptpad";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ martinetd ];
  };

  nodes.machine = {
    environment.systemPackages = [
      pkgs.firefox-unwrapped
    ];
    services.cryptpad = {
      enable = true;
      configureNginx = true;
      settings = {
        httpUnsafeOrigin = "https://cryptpad.localhost";
        httpSafeOrigin = "https://cryptpad-sandbox.localhost";
      };
    };
    services.nginx = {
      virtualHosts."cryptpad.localhost" = {
        enableACME = false;
        sslCertificate = "${certs}/cert.pem";
        sslCertificateKey = "${certs}/key.pem";
      };
    };
    security = {
      pki.certificateFiles = [ "${certs}/cert.pem" ];
    };
  };

  testScript = ''
    machine.wait_for_unit("cryptpad.service")
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(3000)

    # test home page
    machine.succeed("curl --fail https://cryptpad.localhost -o /tmp/cryptpad_home.html")
    machine.succeed("grep -F 'CryptPad: Collaboration suite' /tmp/cryptpad_home.html")

    # test scripts/build.js actually generated customize content from config
    machine.succeed("grep -F 'meta property=\"og:url\" content=\"https://cryptpad.localhost/index.html' /tmp/cryptpad_home.html")

    # make sure child pages are accessible (e.g. check nginx try_files paths)
    machine.succeed(
        "grep -oE '/(customize|components)[^\"]*' /tmp/cryptpad_home.html"
        "  | while read -r page; do"
        "        curl -O --fail https://cryptpad.localhost$page || exit;"
        "    done")

    # test some API (e.g. check cryptpad main process)
    machine.succeed("curl --fail -d @${test_write_data} -H 'Content-Type: application/json' https://cryptpad.localhost/api/auth")

    # page loads
    machine.succeed("${lib.getExe seleniumScript}")

    # test telemetry has been disabled
    machine.fail("journalctl -u cryptpad | grep TELEMETRY");

    # for future improvements
    machine.log(machine.execute("systemd-analyze security cryptpad.service")[1])
  '';
}
