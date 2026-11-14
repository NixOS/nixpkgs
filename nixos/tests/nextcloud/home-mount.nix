{
  name,
  testBase,
  package,
  ...
}:

{ config, lib, ... }:
{
  inherit name;
  meta.maintainers = lib.teams.nextcloud.members;

  imports = [ testBase ];

  nodes.nextcloud = { pkgs, ... }: {
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
