{ lib, pkgs, ... }:

let
  lib = pkgs.lib;

in
{
  name = "chromadb";
  meta.maintainers = [ ];

  nodes = {
    machine =
      { pkgs, ... }:
      {
        services.chromadb = {
          enable = true;
        };
      };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("chromadb.service")
    machine.wait_for_open_port(8000)
  '';
}
