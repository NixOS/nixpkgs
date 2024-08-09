# nix-build -A nixosTests.docker-tools-nix-shell
{ config, lib, ... }:
let
  inherit (config.node.pkgs.dockerTools) examples;
in
{
  name = "docker-tools-nix-shell";
  meta = with lib.maintainers; {
    maintainers = [
      infinisil
      roberth
    ];
  };

  nodes = {
    docker =
      { ... }:
      {
        virtualisation = {
          diskSize = 3072;
          docker.enable = true;
        };
      };
  };

  testScript = ''
    docker.wait_for_unit("sockets.target")

    with subtest("buildImageWithNixDB: Has a nix database"):
        docker.succeed(
            "docker load --input='${examples.nix}'",
            "docker run --rm ${examples.nix.imageName} nix-store -q --references /bin/bash"
        )

    with subtest("buildNixShellImage: Can build a basic derivation"):
        docker.succeed(
            "${examples.nix-shell-basic} | docker load",
            "docker run --rm nix-shell-basic bash -c 'buildDerivation && $out/bin/hello' | grep '^Hello, world!$'"
        )

    with subtest("buildNixShellImage: Runs the shell hook"):
        docker.succeed(
            "${examples.nix-shell-hook} | docker load",
            "docker run --rm -it nix-shell-hook | grep 'This is the shell hook!'"
        )

    with subtest("buildNixShellImage: Sources stdenv, making build inputs available"):
        docker.succeed(
            "${examples.nix-shell-inputs} | docker load",
            "docker run --rm -it nix-shell-inputs | grep 'Hello, world!'"
        )

    with subtest("buildNixShellImage: passAsFile works"):
        docker.succeed(
            "${examples.nix-shell-pass-as-file} | docker load",
            "docker run --rm -it nix-shell-pass-as-file | grep 'this is a string'"
        )

    with subtest("buildNixShellImage: run argument works"):
        docker.succeed(
            "${examples.nix-shell-run} | docker load",
            "docker run --rm -it nix-shell-run | grep 'This shell is not interactive'"
        )

    with subtest("buildNixShellImage: command argument works"):
        docker.succeed(
            "${examples.nix-shell-command} | docker load",
            "docker run --rm -it nix-shell-command | grep 'This shell is interactive'"
        )

    with subtest("buildNixShellImage: home directory is writable by default"):
        docker.succeed(
            "${examples.nix-shell-writable-home} | docker load",
            "docker run --rm -it nix-shell-writable-home"
        )

    with subtest("buildNixShellImage: home directory can be made non-existent"):
        docker.succeed(
            "${examples.nix-shell-nonexistent-home} | docker load",
            "docker run --rm -it nix-shell-nonexistent-home"
        )

    with subtest("buildNixShellImage: can build derivations"):
        docker.succeed(
            "${examples.nix-shell-build-derivation} | docker load",
            "docker run --rm -it nix-shell-build-derivation"
        )

    with subtest("streamLayeredImage: with nix db"):
        docker.succeed(
            "${examples.nix-layered} | docker load",
            "docker run --rm ${examples.nix-layered.imageName} nix-store -q --references /bin/bash"
        )
  '';
}
