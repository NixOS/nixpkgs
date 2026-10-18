{
  mkPackage ? builtins.getAttr "nginx",
  name ? "default",
  ...
}:
{
  name = "nginx-globalredirect-${name}";

  nodes = {
    webserver =
      { pkgs, lib, ... }:
      {
        services.nginx = {
          enable = true;
          package = mkPackage pkgs;
          virtualHosts.localhost = {
            globalRedirect = "other.example.com";
            # Add an exception
            locations."/noredirect".return = "200 'foo'";
          };
        };
      };
  };

  testScript = ''
    webserver.wait_for_unit("nginx")
    webserver.wait_for_open_port(80)

    webserver.succeed("curl --fail -si http://localhost/alf | grep '^Location:.*/alf'")
    webserver.fail("curl --fail -si http://localhost/noredirect | grep '^Location:'")
  '';
}
