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

    nodes.nextcloud = { pkgs, ... }: {
      system.activationScripts.nc-mock-mount = {
        deps = [ "users" ];
        text = ''
          ${pkgs.coreutils}/bin/mkdir -p /mnt
          ${pkgs.util-linux}/bin/mount -t tmpfs tmpfs /mnt
        '';
      };
      services.nextcloud = {
        config.dbtype = "sqlite";
        home = "/mnt/nextcloud";
      };
    };
  }
)
