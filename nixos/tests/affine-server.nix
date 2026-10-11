{ lib, pkgs, ... }:

let
  certs = import ./common/acme/server/snakeoil-certs.nix;
  inherit (certs) domain;
  testRunner =
    pkgs.writers.writePython3Bin "test-runner"
      {
        libraries = [ pkgs.python3Packages.selenium ];
        flakeIgnore = [ "E501" ];
      }
      ''
        import sys

        from selenium.webdriver import Remote
        from selenium.webdriver.common.by import By
        from selenium.webdriver.firefox.options import Options
        from selenium.webdriver.firefox.remote_connection import FirefoxRemoteConnection
        from selenium.webdriver.firefox.service import Service
        from selenium.webdriver.remote.client_config import ClientConfig
        from selenium.webdriver.support import expected_conditions as EC
        from selenium.webdriver.support.ui import WebDriverWait

        options = Options()
        options.binary_location = "${lib.getExe pkgs.firefox-unwrapped}"
        options.add_argument("--headless")
        options.set_preference("browser.startup.page", 0)
        options.set_preference("browser.startup.homepage", "about:blank")
        options.set_preference("browser.newtabpage.enabled", False)
        service = Service(
            executable_path="${lib.getExe pkgs.geckodriver}",
            log_output=sys.stdout,
        )

        print("Starting Firefox", flush=True)
        try:
            service.start()
            connection = FirefoxRemoteConnection(
                remote_server_addr=service.service_url,
                client_config=ClientConfig(
                    remote_server_addr=service.service_url,
                    timeout=600,
                ),
            )
            with Remote(command_executor=connection, options=options) as driver:
                driver.set_page_load_timeout(180)
                print("Opening AFFiNE", flush=True)
                driver.get("https://${domain}/")
                wait = WebDriverWait(driver, 180)
                print("Waiting for setup redirect", flush=True)
                wait.until(EC.url_to_be("https://${domain}/admin/setup"))
                print("Waiting for setup heading", flush=True)
                wait.until(EC.visibility_of_element_located(
                    (By.XPATH, "//h1[normalize-space(.)='Welcome to AFFiNE']")
                ))
                print("First-run setup visible", flush=True)
        finally:
            service.stop()
      '';
in

{
  name = "affine-server";
  requiredFeatures.kvm = false;

  meta.maintainers = with lib.maintainers; [
    vagahbond
  ];

  nodes.machine = {
    virtualisation.memorySize = 2048;
    environment.systemPackages = [
      pkgs.firefox-unwrapped
      pkgs.geckodriver
      testRunner
    ];

    networking.hosts."127.0.0.1" = [ domain ];
    security.pki.certificateFiles = [ certs.ca.cert ];

    services.nginx.virtualHosts."${domain}" = {
      forceSSL = lib.mkForce true;
      sslCertificate = certs.${domain}.cert;
      sslCertificateKey = certs.${domain}.key;

    };

    services.affine-server = {
      enable = true;

      nginx = {
        enable = true;
        enableACME = false;
      };
      database.createLocally = true;

      redis.createLocally = true;

      settings = {
        server.host = domain;
        # will be set automatically
        crypto.privateKey = null;
      };
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("affine-server.service")
    machine.wait_for_open_port(3210)
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(443)

    with subtest("HTTPS endpoint responds"):
        machine.wait_until_succeeds(
            "curl --fail --silent --show-error --location --max-time 10 "
            "https://${domain}/ --output /dev/null",
            timeout=120,
        )

    with subtest("web interface presents first-run setup"):
        machine.succeed(
            "PYTHONUNBUFFERED=1 test-runner",
            timeout=1200,
        )

  '';
}
