{
  lib,
  pkgs,
  ...
}:

{
  name = "lauti";
  meta.maintainers = with lib.maintainers; [ onny ];

  nodes = {
    lauti = {
      services.lauti.enable = true;
    };
  };

  testScript = ''
    lauti.start
    lauti.wait_for_unit("lauti.service")
    lauti.wait_for_open_port(3333)
    lauti.succeed("curl -sSfL http://lauti:3333 | grep 'No events available'")
  '';

}
