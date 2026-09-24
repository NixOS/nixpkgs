# This test validates the docker autoprune service, testing whether
# the default configuration cleans up images, while leaving volumes intact
# and whether the allVolumes option enables cleaning up volumes as well
{ pkgs, ... }:
{
  name = "docker";

  nodes = {
    prune =
      { pkgs, ... }:
      {
        virtualisation.docker = {
          enable = true;
          package = pkgs.docker;
          autoPrune = {
            enable = true;
          };
        };
      };
    prunevolumes =
      { pkgs, ... }:
      {
        virtualisation.docker = {
          enable = true;
          package = pkgs.docker;
          autoPrune = {
            enable = true;
            allVolumes.enable = true;
          };
        };
      };
  };

  testScript = ''
    start_all()

    with subtest("Check whether autoPrune works. Volumes should be left unpruned."):
      prune.wait_for_unit("sockets.target")
      prune.succeed("docker network create testnetwork")
      prune.succeed("docker network list --format json | grep testnetwork")
      prune.succeed("docker volume create testvolume")
      prune.succeed("docker volume list --format json | grep testvolume")

      prune.succeed("systemctl start -v docker-prune")
      prune.fail("docker network list --format json | grep testnetwork")
      # the volume has been left alone
      prune.succeed("docker volume list --format json | grep testvolume")

    with subtest("Check whether autoPrune including volumes works"):
      prunevolumes.wait_for_unit("sockets.target")
      prunevolumes.succeed("docker volume create testvolume")
      prunevolumes.succeed("docker volume list --format json | grep testvolume")

      prunevolumes.succeed("systemctl start -v docker-prune")
      prunevolumes.fail("docker volume list --format json | grep testvolume")
  '';
}
