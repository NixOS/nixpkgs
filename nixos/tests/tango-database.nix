{
  pkgs,
  lib,
  ...
}:
let
  test-path-on-vm = "/tmp/test-artifacts";
  tango-db-with-tests = pkgs.tango-database.overrideAttrs (oldAttrs: {
    cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
      "-DBUILD_TESTING=ON"
      "-DTANGO_DB_NAME=tango_database_ci"
      "-DMYSQL_ADMIN=tango"
      "-DMYSQL_ADMIN_PASSWD=tango"
    ];

    # boost required for boost.test, pkg-config for finding boost
    buildInputs = (oldAttrs.buildInputs or [ ]) ++ [
      pkgs.pkg-config
      pkgs.boost
    ];

    postInstall = ''
      # persist build/ into the output, so we can run tests later
      mkdir -p $out/test-artifacts
      cp -r ./. $out/test-artifacts/

      find $out/test-artifacts -type f -exec sed -i "s|$NIX_BUILD_TOP/source/build|${test-path-on-vm}|g" {} +
    '';
  });
in
{
  name = "tango-database";
  meta = {
    maintainers = [ lib.maintainers.gilice ];
  };

  nodes.machine = { pkgs, ... }: {
    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
      ensureDatabases = [ "tango_database_ci" ];
      initialScript = pkgs.writeText "mysql-init.sql" ''
        CREATE USER IF NOT EXISTS 'tango'@'localhost' IDENTIFIED BY 'tango';
        GRANT ALL PRIVILEGES ON tango_database_ci.* TO 'tango'@'localhost';
        FLUSH PRIVILEGES;
      '';
    };

    environment.systemPackages = [
      tango-db-with-tests
      pkgs.cmake
    ];
  };

  testScript = ''
    machine.wait_for_unit("mysql.service")
    machine.succeed("cp -r ${tango-db-with-tests}/test-artifacts/ ./test-artifacts")
    machine.succeed("""
      cd test-artifacts
      export TANGO_HOST=127.0.0.1:10000
      # systemd-cat is to stream test progress to the vm log
      ctest --output-on-failure |& systemd-cat
    """)
  '';
}
