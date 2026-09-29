{ lib, ... }:
{
  name = "firefly-iii-data-importer";
  meta = {
    maintainers = [ lib.maintainers.savyajha ];
    platforms = lib.platforms.linux;
  };

  nodes.dataImporter =
    { ... }:
    {
      services.firefly-iii-data-importer = {
        enable = true;
        enableNginx = true;
        settings = {
          LOG_CHANNEL = "stdout";
          USE_CACHE = true;
          VERIFY_TLS_SECURITY = true;
          IGNORE_DUPLICATE_ERRORS = false;
        };
      };
    };

  testScript =
    { nodes, ... }:
    let
      cfg = nodes.dataImporter.services.firefly-iii-data-importer;
    in
    ''
      dataImporter.wait_for_unit("phpfpm-firefly-iii-data-importer.service")
      dataImporter.wait_for_unit("nginx.service")
      dataImporter.succeed("""
        ${cfg.package.phpPackage}/bin/php -r '
          $config = require "${cfg.dataDir}/cache/config.php";
          exit($config["importer"]["connection"]["verify"] === true
            && $config["importer"]["ignore_duplicate_errors"] === false ? 0 : 1);
        '
      """)
      dataImporter.succeed("curl -fvvv -Ls http://localhost/token | grep 'Firefly III Data Import Tool'")
    '';
}
