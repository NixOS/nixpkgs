import ./make-test-python.nix ({ pkgs, lib, ... }:

/*
  This test suite replaces the typical pytestCheckHook function in
  sqlite3-to-mysql due to the need of a running mysql instance.
*/

{
  name = "sqlite3-to-mysql";
  meta.maintainers = with lib.maintainers; [ gador ];

  nodes.machine = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      sqlite3-to-mysql
      # create one coherent python environment
      (python3.withPackages
        (ps: sqlite3-to-mysql.propagatedBuildInputs ++
          [
            python3Packages.pytest
            python3Packages.pytest-mock
            python3Packages.pytest-timeout
            python3Packages.factory_boy
            python3Packages.docker # only needed so import does not fail
            sqlite3-to-mysql
          ])
      )
    ];
    services.mysql = {
      package = pkgs.mariadb;
      enable = true;
      # from https://github.com/techouse/sqlite3-to-mysql/blob/master/tests/conftest.py
      # and https://github.com/techouse/sqlite3-to-mysql/blob/master/.github/workflows/test.yml
      initialScript = pkgs.writeText "mysql-init.sql" ''
        create database test_db DEFAULT CHARACTER SET utf8mb4;
        create user tester identified by 'testpass';
        grant all on test_db.* to tester;
        create user tester@localhost identified by 'testpass';
        grant all on test_db.* to tester@localhost;
      '';
      settings = {
        mysqld = {
          character-set-server = "utf8mb4";
          collation-server = "utf8mb4_unicode_ci";
          log_warnings = 1;
        };
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("mysql")

    machine.succeed(
         "sqlite3mysql --version | grep ${pkgs.sqlite3-to-mysql.version}"
    )

    # invalid_database_name: assert '1045 (28000): Access denied' in "1044 (42000): Access denied [...]
    # invalid_database_user: does not return non-zero exit for some reason
    # test_version: has problems importing sqlite3_to_mysql and determining the version
    machine.succeed(
         "cd ${pkgs.sqlite3-to-mysql.src} \
          && pytest -v --no-docker -k \"not test_invalid_database_name and not test_invalid_database_user and not test_version\""
    )
  '';
})
