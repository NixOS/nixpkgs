let
  pkgs = import <nixpkgs> { };
in
with import <nixpkgs/nixos/lib/testing.nix> { inherit pkgs; system = builtins.currentSystem; };
with pkgs.lib;

makeTest {
    name = "pg-initdb";

    machine = {...}:
      {
        documentation.enable = false;
        services.postgresql.enable = true;
        services.postgresql.package = pkgs.postgresql_9_6;
        environment.pathsToLink = [
          "/share/postgresql"
        ];
      };

    testScript = ''
      $machine->start;
      $machine->succeed("sudo -u postgres initdb -D /tmp/testpostgres2");
      $machine->shutdown;
    '';

  }