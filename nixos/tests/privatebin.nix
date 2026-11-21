{ lib, ... }:

{
  name = "privatebin";
  meta.maintainers = [ lib.maintainers.savyajha ];

  nodes.privatebin =
    { ... }:
    {
      services.privatebin = {
        enable = true;
        enableNginx = true;
      };
    };

  testScript = ''
    privatebin.wait_for_unit("phpfpm-privatebin.service")
    privatebin.wait_for_unit("nginx.service")
    privatebin.succeed("curl -fvvv -Ls http://localhost/ | grep 'PrivateBin'")
  '';
}
