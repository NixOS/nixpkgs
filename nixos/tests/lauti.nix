{
  lib,
  pkgs,
  ...
}:

{
  name = "eintopf";
  meta.maintainers = with lib.maintainers; [ onny ];

  nodes = {
    eintopf = {
      services.eintopf.enable = true;
    };
  };

  testScript = ''
    eintopf.start
    eintopf.wait_for_unit("eintopf.service")
    eintopf.wait_for_open_port(3333)
    eintopf.succeed("curl -sSfL http://eintopf:3333 | grep 'No events available'")
  '';

}
