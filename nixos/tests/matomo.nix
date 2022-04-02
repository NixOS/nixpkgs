{ system ? builtins.currentSystem, config ? { }
, pkgs ? import ../.. { inherit system config; } }:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  matomoTest = package:
  makeTest {
    nodes.machine = { config, pkgs, ... }: {
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
        package = pkgs.mariadb;
      };
      services.nginx.enable = true;
    };

    testScript = ''
      start_all()
      machine.wait_for_unit("mysql.service")
      machine.wait_for_unit("phpfpm-matomo.service")
      machine.wait_for_unit("nginx.service")

      # without the grep the command does not produce valid utf-8 for some reason
      with subtest("welcome screen loads"):
          machine.succeed(
              "curl -sSfL http://localhost/ | grep '<title>Matomo[^<]*Installation'"
          )
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
