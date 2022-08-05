import ./make-test-python.nix ({ pkgs, ... }: let
  dbPassword = "secretdbpassword";
  passwordFile = toString (pkgs.writeText "dolibarr-db-pass-file" dbPassword);
in {
  name = "dolibarr";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ shamilton ];
  };

  nodes.machine = { ... }: {
    environment.systemPackages = let
      auto-install-dolibarr = pkgs.writers.writePython3Bin "auto-install-dolibarr" {
        libraries = [ pkgs.python3Packages.selenium ];
      } ''
        from selenium.webdriver import Firefox
        from selenium.webdriver.firefox.options import Options
        from selenium.webdriver.support.wait import WebDriverWait
        from selenium.webdriver.support import expected_conditions as EC
        from selenium.webdriver.common.by import By

        options = Options()
        options.add_argument('--headless')
        print("Starting...")
        driver = Firefox(options=options)

        print("Opening http://localhost/install...")
        driver.get('http://localhost/install/')
        print("Starting sequence...")
        driver.find_element(
          'xpath',
          '/html/body/form/table/tbody/tr/td/table/tbody/' +
          'tr/td/table/tbody/tr[22]/td[3]/a'
        ).click()
        tmp = driver.find_element('xpath', '//*[@id="main_data_dir"]')
        tmp.clear()
        tmp.send_keys("/var/lib/dolibarr/documents")

        tmp = driver.find_element('xpath', '//*[@id="db_pass"]')
        tmp.clear()
        tmp.send_keys('${dbPassword}')

        driver.find_element('xpath', '/html/body/form/div/input').click()
        driver.find_element('xpath', '/html/body/form/div[1]/input').click()

        print("Waiting for installation to complete...")
        WebDriverWait(driver, 60).until(
          EC.element_to_be_clickable((By.XPATH, "/html/body/form/div/input"))
        )

        print("Configuring the admin credentials...")
        driver.find_element('xpath', '/html/body/form/div/input').click()

        driver.find_element('xpath', '/html/body/form/div/input').click()

        tmp = driver.find_element('xpath', '//*[@id="login"]')
        tmp.clear()
        tmp.send_keys('admin')

        tmp = driver.find_element('xpath', '//*[@id="pass"]')
        tmp.clear()
        tmp.send_keys('password')

        tmp = driver.find_element('xpath', '//*[@id="pass_verif"]')
        tmp.clear()
        tmp.send_keys('password')

        driver.find_element('xpath', '/html/body/form/div/input').click()

        driver.find_element(
          'xpath',
          '/html/body/form/table/tbody/tr/td/table/tbody/tr/td/div[2]/a'
        ).click()

        print("Done")
      '';
    in [ pkgs.firefox-unwrapped pkgs.geckodriver auto-install-dolibarr ];

    services.dolibarr = {
      enable = true;
      domain = "localhost";
      preInstalled = false;
      initialDbPasswordFile = passwordFile;
    };
  };

  testScript = let
    mysqlCreds = pkgs.writeText "mysql-creds" ''
      [client]
      user=dolibarr
      password=${dbPassword}
    '';
  in ''
    start_all()

    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("nginx.service")
    machine.wait_for_unit("mysql.service")
    machine.wait_for_unit("phpfpm-dolibarr.service")
    machine.succeed("echo passwordfile is='${passwordFile}' >&2")
    machine.succeed("cat ${passwordFile} >&2")
    machine.succeed("cat ${mysqlCreds} >&2")
    machine.succeed(
      "echo 'SELECT User,Host,Password FROM mysql.user;' | mysql -u root >&2"
    )
    machine.succeed(
      "echo 'SHOW DATABASES;' | mysql --defaults-extra-file=${mysqlCreds} -u dolibarr -N >&2"
    )
    machine.succeed("cat /etc/dolibarr/conf.php >&2")
    machine.succeed("auto-install-dolibarr >&2")
    machine.succeed("${pkgs.mariadb}/bin/mysqldump -u root dolibarr > /tmp/dolibarr-db.sql")
    machine.copy_from_vm("/tmp/dolibarr-db.sql")
  '';
})
