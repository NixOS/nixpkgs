# this test creates a simple GNU image with docker tools and sees if it executes

import ./make-test-python.nix ({ pkgs, ... }: {
  name = "docker-tools";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ lnl7 ];
  };

  nodes = {
    docker = { ... }: {
      virtualisation = {
        diskSize = 2048;
        docker.enable = true;
      };
    };
  };

  testScript = with pkgs.dockerTools; ''
    unix_time_second1 = "1970-01-01T00:00:01Z"

    docker.wait_for_unit("sockets.target")

    with subtest("Ensure Docker images use a stable date by default"):
        docker.succeed(
            "docker load --input='${examples.bash}'"
        )
        assert unix_time_second1 in docker.succeed(
            "docker inspect ${examples.bash.imageName} "
            + "| ${pkgs.jq}/bin/jq -r .[].Created",
        )

    docker.succeed("docker run --rm ${examples.bash.imageName} bash --version")
    docker.succeed("docker rmi ${examples.bash.imageName}")

    with subtest(
        "Check if the nix store is correctly initialized by listing "
        "dependencies of the installed Nix binary"
    ):
        docker.succeed(
            "docker load --input='${examples.nix}'",
            "docker run --rm ${examples.nix.imageName} nix-store -qR ${pkgs.nix}",
            "docker rmi ${examples.nix.imageName}",
        )

    with subtest("The pullImage tool works"):
        docker.succeed(
            "docker load --input='${examples.nixFromDockerHub}'",
            "docker run --rm nix:2.2.1 nix-store --version",
            "docker rmi nix:2.2.1",
        )

    with subtest("runAsRoot and entry point work"):
        docker.succeed(
            "docker load --input='${examples.nginx}'",
            "docker run --name nginx -d -p 8000:80 ${examples.nginx.imageName}",
        )
        docker.wait_until_succeeds("curl http://localhost:8000/")
        docker.succeed(
            "docker rm --force nginx", "docker rmi '${examples.nginx.imageName}'",
        )

    with subtest("A pulled image can be used as base image"):
        docker.succeed(
            "docker load --input='${examples.onTopOfPulledImage}'",
            "docker run --rm ontopofpulledimage hello",
            "docker rmi ontopofpulledimage",
        )

    with subtest("Regression test for issue #34779"):
        docker.succeed(
            "docker load --input='${examples.runAsRootExtraCommands}'",
            "docker run --rm runasrootextracommands cat extraCommands",
            "docker run --rm runasrootextracommands cat runAsRoot",
            "docker rmi '${examples.runAsRootExtraCommands.imageName}'",
        )

    with subtest("Ensure Docker images can use an unstable date"):
        docker.succeed(
            "docker load --input='${examples.bash}'"
        )
        assert unix_time_second1 not in docker.succeed(
            "docker inspect ${examples.unstableDate.imageName} "
            + "| ${pkgs.jq}/bin/jq -r .[].Created"
        )

    with subtest("Ensure Layered Docker images work"):
        docker.succeed(
            "docker load --input='${examples.layered-image}'",
            "docker run --rm ${examples.layered-image.imageName}",
            "docker run --rm ${examples.layered-image.imageName} cat extraCommands",
        )

    with subtest("Ensure building an image on top of a layered Docker images work"):
        docker.succeed(
            "docker load --input='${examples.layered-on-top}'",
            "docker run --rm ${examples.layered-on-top.imageName}",
        )


    def set_of_layers(image_name):
        return set(
            docker.succeed(
                f"docker inspect {image_name} "
                + "| ${pkgs.jq}/bin/jq -r '.[] | .RootFS.Layers | .[]'"
            ).split()
        )


    with subtest("Ensure layers are shared between images"):
        docker.succeed(
            "docker load --input='${examples.another-layered-image}'"
        )
        layers1 = set_of_layers("${examples.layered-image.imageName}")
        layers2 = set_of_layers("${examples.another-layered-image.imageName}")
        assert bool(layers1 & layers2)

    with subtest("Ensure order of layers is correct"):
        docker.succeed(
            "docker load --input='${examples.layersOrder}'"
        )

        for index in 1, 2, 3:
            assert f"layer{index}" in docker.succeed(
                f"docker run --rm  ${examples.layersOrder.imageName} cat /tmp/layer{index}"
            )

    with subtest("Ensure image with only 2 layers can be loaded"):
        docker.succeed(
            "docker load --input='${examples.two-layered-image}'"
        )

    with subtest(
        "Ensure the bulk layer doesn't miss store paths (regression test for #78744)"
    ):
        docker.succeed(
            "docker load --input='${pkgs.dockerTools.examples.bulk-layer}'",
            # Ensure the two output paths (ls and hello) are in the layer
            "docker run bulk-layer ls /bin/hello",
        )

    with subtest("Ensure correct behavior when no store is needed"):
        # This check tests two requirements simultaneously
        #  1. buildLayeredImage can build images that don't need a store.
        #  2. Layers of symlinks are eliminated by the customization layer.
        #
        docker.succeed(
            "docker load --input='${pkgs.dockerTools.examples.no-store-paths}'"
        )

        # Busybox will not recognize argv[0] and print an error message with argv[0],
        # but it confirms that the custom-true symlink is present.
        docker.succeed("docker run --rm no-store-paths custom-true |& grep custom-true")

        # This check may be loosened to allow an *empty* store rather than *no* store.
        docker.succeed("docker run --rm no-store-paths ls /")
        docker.fail("docker run --rm no-store-paths ls /nix/store")
  '';
})
