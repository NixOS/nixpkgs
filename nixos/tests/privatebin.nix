{ lib, ... }:

{
  name = "privatebin";
  meta.maintainers = [ lib.maintainers.savyajha ];

  nodes.dataImporter =
    { ... }:
    {
      services.privatebin = {
        enable = true;
        enableNginx = true;
      };
    };

  testScript = ''
    dataImporter.wait_for_unit("phpfpm-privatebin.service")
    dataImporter.wait_for_unit("nginx.service")
    dataImporter.succeed("curl -fvvv -Ls http://localhost/ | grep 'PrivateBin'")
  '';
}
