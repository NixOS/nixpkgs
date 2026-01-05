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
        };
      };
    };

  testScript = ''
    dataImporter.wait_for_unit("phpfpm-firefly-iii-data-importer.service")
    dataImporter.wait_for_unit("nginx.service")
    dataImporter.succeed("curl -fvvv -Ls http://localhost/token | grep 'Firefly III Data Import Tool'")
  '';
}
