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
          virtualHosts."different-code.localhost" = {
            globalRedirect = "example.com/foo";
            # With 308 (and 307), the method and body are to be kept when following it
            redirectCode = 308;
          };
        };
      };
  };

  testScript = ''
    webserver.wait_for_unit("nginx")
    webserver.wait_for_open_port(80)

    webserver.succeed("curl --fail -si http://localhost/alf | grep '^Location:.*/alf'")
    webserver.fail("curl --fail -si http://localhost/noredirect | grep '^Location:'")

    # Check the status code
    webserver.succeed("curl -H 'Host: different-code.localhost' -si http://localhost | grep '^HTTP/[0-9.]\+ 308 Permanent Redirect'")
  '';
}
