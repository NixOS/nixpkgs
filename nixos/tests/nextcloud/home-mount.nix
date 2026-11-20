{
  name,
  testBase,
  package,
  flavor ? "nodes",
  ...
}:

assert flavor == "nodes";

{ config, lib, ... }:
{
  inherit name;
  meta.maintainers = lib.teams.nextcloud.members;

  imports = [ testBase ];

  ${flavor}.nextcloud = { pkgs, ... }: {
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
