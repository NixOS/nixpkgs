{ lib, pkgs, ... }:

let
  # this is a demo user created by IDM_CREATE_DEMO_USERS=true
  demoUser = "einstein";
  demoPassword = "relativity";

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

        user = sys.argv[1]
        password = sys.argv[2]
        driver.implicitly_wait(20)
        driver.get('https://localhost:9200/login')
        wait = WebDriverWait(driver, 10)
        wait.until(EC.title_contains("Sign in"))
        driver.find_element(By.XPATH, '//*[@id="oc-login-username"]').send_keys(user)
        driver.find_element(By.XPATH, '//*[@id="oc-login-password"]').send_keys(password)
        driver.find_element(By.XPATH, '//*[@id="root"]//button').click()
        wait.until(EC.title_contains("Personal"))
      '';

  # This was generated with `ocis init --config-path testconfig/ --admin-password "hunter2" --insecure true`.
  testConfig = ''
    token_manager:
      jwt_secret: kaKYgfso*d9GA-yTM.&BTOUEuMz%Ai0H
    machine_auth_api_key: sGWRG1JZ&qe&pe@N1HKK4#qH*B&@xLnO
    system_user_api_key: h+m4aHPUtOtUJFKrc5B2=04C=7fDZaT-
    transfer_secret: 4-R6AfUjQn0P&+h2+$skf0lJqmre$j=x
    system_user_id: db180e0a-b38a-4edf-a4cd-a3d358248537
    admin_user_id: ea623f50-742d-4fd0-95bb-c61767b070d4
    graph:
      application:
        id: 11971eab-d560-4b95-a2d4-50726676bbd0
      events:
        tls_insecure: true
      spaces:
        insecure: true
      identity:
        ldap:
          bind_password: ^F&Vn7@mYGYGuxr$#qm^gGy@FVq=.w=y
      service_account:
        service_account_id: df39a290-3f3e-4e39-b67b-8b810ca2abac
        service_account_secret: .demKypQ$=pGl+yRar!#YaFjLYCr4YwE
    idp:
      ldap:
        bind_password: bv53IjS28x.nxth*%aRbE70%4TGNXbLU
    idm:
      service_user_passwords:
        admin_password: hunter2
        idm_password: ^F&Vn7@mYGYGuxr$#qm^gGy@FVq=.w=y
        reva_password: z-%@fWipLliR8lD#fl.0teC#9QbhJ^eb
        idp_password: bv53IjS28x.nxth*%aRbE70%4TGNXbLU
    proxy:
      oidc:
        insecure: true
      insecure_backends: true
      service_account:
        service_account_id: df39a290-3f3e-4e39-b67b-8b810ca2abac
        service_account_secret: .demKypQ$=pGl+yRar!#YaFjLYCr4YwE
    frontend:
      app_handler:
        insecure: true
      archiver:
        insecure: true
      service_account:
        service_account_id: df39a290-3f3e-4e39-b67b-8b810ca2abac
        service_account_secret: .demKypQ$=pGl+yRar!#YaFjLYCr4YwE
    auth_basic:
      auth_providers:
        ldap:
          bind_password: z-%@fWipLliR8lD#fl.0teC#9QbhJ^eb
    auth_bearer:
      auth_providers:
        oidc:
          insecure: true
    users:
      drivers:
        ldap:
          bind_password: z-%@fWipLliR8lD#fl.0teC#9QbhJ^eb
    groups:
      drivers:
        ldap:
          bind_password: z-%@fWipLliR8lD#fl.0teC#9QbhJ^eb
    ocdav:
      insecure: true
    ocm:
      service_account:
        service_account_id: df39a290-3f3e-4e39-b67b-8b810ca2abac
        service_account_secret: .demKypQ$=pGl+yRar!#YaFjLYCr4YwE
    thumbnails:
      thumbnail:
        transfer_secret: 2%11!zAu*AYE&=d*8dfoZs8jK&5ZMm*%
        webdav_allow_insecure: true
        cs3_allow_insecure: true
    search:
      events:
        tls_insecure: true
      service_account:
        service_account_id: df39a290-3f3e-4e39-b67b-8b810ca2abac
        service_account_secret: .demKypQ$=pGl+yRar!#YaFjLYCr4YwE
    audit:
      events:
        tls_insecure: true
    settings:
      service_account_ids:
      - df39a290-3f3e-4e39-b67b-8b810ca2abac
    sharing:
      events:
        tls_insecure: true
    storage_users:
      events:
        tls_insecure: true
      mount_id: ef72cb8b-809c-4592-bfd2-1df603295205
      service_account:
        service_account_id: df39a290-3f3e-4e39-b67b-8b810ca2abac
        service_account_secret: .demKypQ$=pGl+yRar!#YaFjLYCr4YwE
    notifications:
      notifications:
        events:
          tls_insecure: true
      service_account:
        service_account_id: df39a290-3f3e-4e39-b67b-8b810ca2abac
        service_account_secret: .demKypQ$=pGl+yRar!#YaFjLYCr4YwE
    nats:
      nats:
        tls_skip_verify_client_cert: true
    gateway:
      storage_registry:
        storage_users_mount_id: ef72cb8b-809c-4592-bfd2-1df603295205
    userlog:
      service_account:
        service_account_id: df39a290-3f3e-4e39-b67b-8b810ca2abac
        service_account_secret: .demKypQ$=pGl+yRar!#YaFjLYCr4YwE
    auth_service:
      service_account:
        service_account_id: df39a290-3f3e-4e39-b67b-8b810ca2abac
        service_account_secret: .demKypQ$=pGl+yRar!#YaFjLYCr4YwE
    clientlog:
      service_account:
        service_account_id: df39a290-3f3e-4e39-b67b-8b810ca2abac
        service_account_secret: .demKypQ$=pGl+yRar!#YaFjLYCr4YwE'';
in

{
  name = "ocis";

  meta.maintainers = with lib.maintainers; [
    bhankas
    ramblurr
  ];

  nodes.machine =
    { config, ... }:
    {
      virtualisation.memorySize = 2048;
      environment.systemPackages = [
        pkgs.firefox-unwrapped
        pkgs.geckodriver
        testRunner
      ];

      # if you do this in production, dont put secrets in this file because it will be written to the world readable nix store
      environment.etc."ocis/ocis.env".text = ''
        ADMIN_PASSWORD=${adminPassword}
        IDM_CREATE_DEMO_USERS=true
      '';

      # if you do this in production, dont put secrets in this file because it will be written to the world readable nix store
      environment.etc."ocis/config/ocis.yaml".text = testConfig;

      services.ocis = {
        enable = true;
        configDir = "/etc/ocis/config";
        environment = {
          OCIS_INSECURE = "true";
        };
        environmentFile = "/etc/ocis/ocis.env";
      };
    };

  testScript = ''
    start_all()
    machine.wait_for_unit("ocis.service")
    machine.wait_for_open_port(9200)
    # wait for ocis to fully come up
    machine.sleep(5)

    with subtest("ocis bin works"):
        machine.succeed("${lib.getExe pkgs.ocis_5-bin} version")

    with subtest("use the web interface to log in with a demo user"):
        machine.succeed("PYTHONUNBUFFERED=1 systemd-cat -t test-runner test-runner ${demoUser} ${demoPassword}")

    with subtest("use the web interface to log in with the provisioned admin user"):
        machine.succeed("PYTHONUNBUFFERED=1 systemd-cat -t test-runner test-runner ${adminUser} ${adminPassword}")
  '';
}
