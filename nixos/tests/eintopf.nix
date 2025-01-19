import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "eintopf";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ onny ];
    };

    nodes = {
      eintopf =
        { config, pkgs, ... }:
        {
          services.eintopf = {
            enable = true;
          };
        };
    };

    testScript = ''
      eintopf.start
      eintopf.wait_for_unit("eintopf.service")
      eintopf.wait_for_open_port(3333)
      eintopf.succeed("curl -sSfL http://eintopf:3333 | grep 'Es sind keine Veranstaltungen eingetragen'")
    '';
  }
)
