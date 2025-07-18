{ lib, pkgs, ... }:

let
  certs = import ./common/acme/server/snakeoil-certs.nix;
  inherit (certs) domain;

  # this is a demo user created by IDM_CREATE_DEMO_USERS=true
  demoUser = "alan";
  demoPassword = "demo";

  adminUser = "admin";
  adminPassword = "hunter2";
  testRunner =
    pkgs.writers.writePython3Bin "test-runner"
      {
        libraries = [ pkgs.python3Packages.selenium ];
        flakeIgnore = [ "E501" ];
      }
      ''
        import sys
        from selenium.webdriver.common.by import By
        from selenium.webdriver import Firefox
        from selenium.webdriver.firefox.options import Options
        from selenium.webdriver.support.ui import WebDriverWait
        from selenium.webdriver.support import expected_conditions as EC

        options = Options()
        options.add_argument('--headless')
        driver = Firefox(options=options)

        host = sys.argv[1]
        user = sys.argv[2]
        password = sys.argv[3]

        driver.get(f"https://{host}/")
        wait = WebDriverWait(driver, 60)
        wait.until(EC.title_contains("Sign in"))
        wait.until(EC.url_contains(f"https://{host}/signin/v1/identifier"))
        wait.until(EC.visibility_of_element_located((By.ID, 'oc-login-username')))
        driver.find_element(By.ID, 'oc-login-username').send_keys(user)
        driver.find_element(By.ID, 'oc-login-password').send_keys(password)
        wait.until(EC.visibility_of_element_located((By.XPATH, '//button[@type="submit"]')))
        driver.find_element(By.XPATH, '//button[@type="submit"]').click()
        wait.until(EC.visibility_of_element_located((By.ID, 'new-file-menu-btn')))
        wait.until(EC.title_contains("Personal"))
      '';
in

{
  name = "opencloud";

  meta.maintainers = with lib.maintainers; [
    christoph-heiss
    k900
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

    services.opencloud = {
      enable = true;
      url = "https://${domain}:9200";
      environment = {
        ADMIN_PASSWORD = adminPassword;
        IDM_CREATE_DEMO_USERS = "true";
        IDM_LDAPS_CERT = "${certs.${domain}.cert}";
        IDM_LDAPS_KEY = "${certs.${domain}.key}";
        OC_INSECURE = "false";
        OC_LDAP_URI = "ldaps://${domain}:9235";
        OC_LDAP_CACERT = "${certs.${domain}.cert}";
        OC_HTTP_TLS_ENABLED = "true";
        OC_HTTP_TLS_CERTIFICATE = "${certs.${domain}.cert}";
        OC_HTTP_TLS_KEY = "${certs.${domain}.key}";
        PROXY_TLS = "true";
        PROXY_TRANSPORT_TLS_CERT = "${certs.${domain}.cert}";
        PROXY_TRANSPORT_TLS_KEY = "${certs.${domain}.key}";
        PROXY_INSECURE_BACKENDS = "true";
      };
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("opencloud.service")
    machine.wait_for_open_port(9200)

    # wait for OpenCloud to fully come up
    machine.sleep(10)

    with subtest("opencloud bin works"):
        machine.succeed("${lib.getExe pkgs.opencloud} version")

    with subtest("web interface presents start page"):
        machine.succeed("curl -sSf https://${domain}:9200 | grep '<title>OpenCloud</title>'")

    with subtest("use the web interface to log in with the provisioned admin user"):
        machine.succeed("PYTHONUNBUFFERED=1 systemd-cat -t test-runner test-runner ${domain}:9200 ${adminUser} ${adminPassword}")

    with subtest("use the web interface to log in with a demo user"):
        machine.succeed("PYTHONUNBUFFERED=1 systemd-cat -t test-runner test-runner ${domain}:9200 ${demoUser} ${demoPassword}")
  '';
}
