{
  name,
  pkgs,
  testBase,
  system,
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
        home = "/mnt/nextcloud";
      };
    };
  }
)
