{
  name,
  pkgs,
  testBase,
  system,
  package,
  ...
}:

with import ../../lib/testing-python.nix { inherit system pkgs; };
runTest (
  { config, lib, ... }:
  {
    inherit name;
    meta.maintainers = lib.teams.nextcloud.members;

    imports = [ testBase ];

    nodes.nextcloud = {
      fileSystems."/mnt" = {
        fsType = "tmpfs";
        device = "tmpfs";
      };
      services.nextcloud = {
        config.dbtype = "sqlite";
        package = package pkgs;
        home = "/mnt/nextcloud";
      };
    };
  }
)
