{ lib, fetchDocker, runCommand, nix-prefetch-docker, testers }:

lib.recurseIntoAttrs {

  busybox = testers.invalidateFetcherByDrvHash fetchDocker (lib.importJSON ./busybox-1.36.0.json // {
    name = "busybox";
    arch = "amd64";
  });

}
