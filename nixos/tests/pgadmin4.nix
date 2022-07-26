import ./make-test-python.nix ({ pkgs, lib, buildDeps ? [ ], pythonEnv ? [ ], ... }:

  /*
  This test suite replaces the typical pytestCheckHook function in python
  packages. Pgadmin4 test suite needs a running and configured postgresql
  server. This is why this test exists.

  To not repeat all the python dependencies needed, this test is called directly
  from the pgadmin4 derivation, which also passes the currently
  used propagatedBuildInputs and any python overrides.

  Unfortunately, there doesn't seem to be an easy way to otherwise include
  the needed packages here.

  Due the the needed parameters a direct call to "nixosTests.pgadmin4" fails
  and needs to be called as "pgadmin4.tests"

  */

  let
    pgadmin4SrcDir = "/pgadmin";
    pgadmin4Dir = "/var/lib/pgadmin";
    pgadmin4LogDir = "/var/log/pgadmin";

  in
  {
    name = "pgadmin4";
    meta.maintainers = with lib.maintainers; [ gador ];

    nodes.machine = { pkgs, ... }: {
      imports = [ ./common/x11.nix ];
      # needed because pgadmin 6.8 will fail, if those dependencies get updated
      nixpkgs.overlays = [
        (self: super: {
          pythonPackages = pythonEnv;
        })
      ];

      environment.systemPackages = with pkgs; [
        pgadmin4
        postgresql
        chromedriver
        chromium
        # include the same packages as in pgadmin minus speaklater3
        (python3.withPackages
          (ps: buildDeps ++
            [
              # test suite package requirements
              pythonPackages.testscenarios
              pythonPackages.selenium
            ])
        )
      ];
      services.postgresql = {
        enable = true;
        authentication = ''
          host    all             all             localhost               trust
        '';
        ensureUsers = [
          {
            name = "postgres";
            ensurePermissions = {
              "DATABASE \"postgres\"" = "ALL PRIVILEGES";
            };
          }
        ];
      };
    };

    testScript = ''
      machine.wait_for_unit("postgresql")

      # pgadmin4 needs its data and log directories
      machine.succeed(
          "mkdir -p ${pgadmin4Dir} \
          && mkdir -p ${pgadmin4LogDir} \
          && mkdir -p ${pgadmin4SrcDir}"
      )

      machine.succeed(
           "tar xvzf ${pkgs.pgadmin4.src} -C ${pgadmin4SrcDir}"
      )

      machine.wait_for_file("${pgadmin4SrcDir}/pgadmin4-${pkgs.pgadmin4.version}/README.md")

      # set paths and config for tests
      machine.succeed(
           "cd ${pgadmin4SrcDir}/pgadmin4-${pkgs.pgadmin4.version} \
           && cp -v web/regression/test_config.json.in web/regression/test_config.json \
           && sed -i 's|PostgreSQL 9.4|PostgreSQL|' web/regression/test_config.json \
           && sed -i 's|/opt/PostgreSQL/9.4/bin/|${pkgs.postgresql}/bin|' web/regression/test_config.json \
           && sed -i 's|\"headless_chrome\": false|\"headless_chrome\": true|' web/regression/test_config.json"
      )

      # adapt chrome config to run within a sandbox without GUI
      # see https://stackoverflow.com/questions/50642308/webdriverexception-unknown-error-devtoolsactiveport-file-doesnt-exist-while-t#50642913
      # add chrome binary path. use spaces to satisfy python indention (tabs throw an error)
      # this works for selenium 3 (currently used), but will need to be updated
      # to work with "from selenium.webdriver.chrome.service import Service" in selenium 4
      machine.succeed(
           "cd ${pgadmin4SrcDir}/pgadmin4-${pkgs.pgadmin4.version} \
           && sed -i '\|options.add_argument(\"--disable-infobars\")|a \ \ \ \ \ \ \ \ options.binary_location = \"${pkgs.chromium}/bin/chromium\"' web/regression/runtests.py \
           && sed -i '\|options.add_argument(\"--no-sandbox\")|a \ \ \ \ \ \ \ \ options.add_argument(\"--headless\")' web/regression/runtests.py \
           && sed -i '\|options.add_argument(\"--disable-infobars\")|a \ \ \ \ \ \ \ \ options.add_argument(\"--disable-dev-shm-usage\")' web/regression/runtests.py \
           && sed -i 's|(chrome_options=options)|(executable_path=\"${pkgs.chromedriver}/bin/chromedriver\", chrome_options=options)|' web/regression/runtests.py \
           && sed -i 's|driver_local.maximize_window()||' web/regression/runtests.py"
      )

      # don't bother to test LDAP authentification
      # exclude resql test due to recent postgres 14.4 update
      # see bugreport here https://redmine.postgresql.org/issues/7527
      with subtest("run browser test"):
          machine.succeed(
               'cd ${pgadmin4SrcDir}/pgadmin4-${pkgs.pgadmin4.version}/web \
               && python regression/runtests.py \
               --pkg browser \
               --exclude browser.tests.test_ldap_login.LDAPLoginTestCase,browser.tests.test_ldap_login,resql'
          )

      # fontconfig is necessary for chromium to run
      # https://github.com/NixOS/nixpkgs/issues/136207
      with subtest("run feature test"):
          machine.succeed(
              'cd ${pgadmin4SrcDir}/pgadmin4-${pkgs.pgadmin4.version}/web \
               && export FONTCONFIG_FILE=${pkgs.makeFontsConf { fontDirectories = [];}} \
               && python regression/runtests.py --pkg feature_tests'
          )

      # reactivate this test again, when the postgres 14.4 test has been fixed
      # with subtest("run resql test"):
      #    machine.succeed(
      #         'cd ${pgadmin4SrcDir}/pgadmin4-${pkgs.pgadmin4.version}/web \
      #         && python regression/runtests.py --pkg resql'
      #    )
    '';
  })
