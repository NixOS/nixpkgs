{ system ? builtins.currentSystem, config ? { }
, pkgs ? import ../.. { inherit system config; } }:

with import ../lib/testing.nix { inherit system pkgs; };
with pkgs.lib;

let
  matomoTest = package:
  makeTest {
    machine = { config, pkgs, ... }: {
      services.matomo = {
        package = package;
        enable = true;
        nginx = {
          forceSSL = false;
          enableACME = false;
        };
      };
      services.mysql = {
        enable = true;
        package = pkgs.mysql;
      };
      services.nginx.enable = true;
    };

    testScript = ''
      startAll;
      $machine->waitForUnit("mysql.service");
      $machine->waitForUnit("phpfpm-matomo.service");
      $machine->waitForUnit("nginx.service");
      $machine->succeed("curl -sSfL http://localhost/ | grep '<title>Matomo[^<]*Installation'");
    '';
  };
in {
  matomo = matomoTest pkgs.matomo // {
    name = "matomo";
    meta.maintainers = with maintainers; [ florianjacob kiwi mmilata ];
  };
  matomo-beta = matomoTest pkgs.matomo-beta // {
    name = "matomo-beta";
    meta.maintainers = with maintainers; [ florianjacob kiwi mmilata ];
  };
}
