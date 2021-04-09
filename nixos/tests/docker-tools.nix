# this test creates a simple GNU image with docker tools and sees if it executes

import ./make-test-python.nix ({ pkgs, ... }: {
  name = "docker-tools";
  meta = with pkgs.lib.maintainers; {
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
    # Check imageTag attribute matches image
    docker.succeed("docker images --format '{{.Tag}}' | grep -F '${examples.bash.imageTag}'")
    docker.succeed("docker rmi ${examples.bash.imageName}")

    # The remaining combinations
    with subtest("Ensure imageTag attribute matches image"):
        docker.succeed(
            "docker load --input='${examples.bashNoTag}'"
        )
        docker.succeed(
            "docker images --format '{{.Tag}}' | grep -F '${examples.bashNoTag.imageTag}'"
        )
        docker.succeed("docker rmi ${examples.bashNoTag.imageName}:${examples.bashNoTag.imageTag}")

        docker.succeed(
            "docker load --input='${examples.bashNoTagLayered}'"
        )
        docker.succeed(
            "docker images --format '{{.Tag}}' | grep -F '${examples.bashNoTagLayered.imageTag}'"
        )
        docker.succeed("docker rmi ${examples.bashNoTagLayered.imageName}:${examples.bashNoTagLayered.imageTag}")

        docker.succeed(
            "${examples.bashNoTagStreamLayered} | docker load"
        )
        docker.succeed(
            "docker images --format '{{.Tag}}' | grep -F '${examples.bashNoTagStreamLayered.imageTag}'"
        )
        docker.succeed(
            "docker rmi ${examples.bashNoTagStreamLayered.imageName}:${examples.bashNoTagStreamLayered.imageTag}"
        )

        docker.succeed(
            "docker load --input='${examples.nixLayered}'"
        )
        docker.succeed("docker images --format '{{.Tag}}' | grep -F '${examples.nixLayered.imageTag}'")
        docker.succeed("docker rmi ${examples.nixLayered.imageName}")


    with subtest(
        "Check if the nix store is correctly initialized by listing "
        "dependencies of the installed Nix binary"
    ):
        docker.succeed(
            "docker load --input='${examples.nix}'",
            "docker run --rm ${examples.nix.imageName} nix-store -qR ${pkgs.nix}",
            "docker rmi ${examples.nix.imageName}",
        )

    with subtest(
        "Ensure (layered) nix store has correct permissions "
        "and that the container starts when its process does not have uid 0"
    ):
        docker.succeed(
            "docker load --input='${examples.bashLayeredWithUser}'",
            "docker run -u somebody --rm ${examples.bashLayeredWithUser.imageName} ${pkgs.bash}/bin/bash -c 'test 555 == $(stat --format=%a /nix) && test 555 == $(stat --format=%a /nix/store)'",
            "docker rmi ${examples.bashLayeredWithUser.imageName}",
        )

    with subtest("The nix binary symlinks are intact"):
        docker.succeed(
            "docker load --input='${examples.nix}'",
            "docker run --rm ${examples.nix.imageName} ${pkgs.bash}/bin/bash -c 'test nix == $(readlink ${pkgs.nix}/bin/nix-daemon)'",
            "docker rmi ${examples.nix.imageName}",
        )

    with subtest("The nix binary symlinks are intact when the image is layered"):
        docker.succeed(
            "docker load --input='${examples.nixLayered}'",
            "docker run --rm ${examples.nixLayered.imageName} ${pkgs.bash}/bin/bash -c 'test nix == $(readlink ${pkgs.nix}/bin/nix-daemon)'",
            "docker rmi ${examples.nixLayered.imageName}",
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
        docker.wait_until_succeeds("curl -f http://localhost:8000/")
        docker.succeed(
            "docker rm --force nginx",
            "docker rmi '${examples.nginx.imageName}'",
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
            "docker load --input='${examples.unstableDate}'"
        )
        assert unix_time_second1 not in docker.succeed(
            "docker inspect ${examples.unstableDate.imageName} "
            + "| ${pkgs.jq}/bin/jq -r .[].Created"
        )

    with subtest("Ensure Layered Docker images can use an unstable date"):
        docker.succeed(
            "docker load --input='${examples.unstableDateLayered}'"
        )
        assert unix_time_second1 not in docker.succeed(
            "docker inspect ${examples.unstableDateLayered.imageName} "
            + "| ${pkgs.jq}/bin/jq -r .[].Created"
        )

    with subtest("Ensure Layered Docker images work"):
        docker.succeed(
            "docker load --input='${examples.layered-image}'",
            "docker run --rm ${examples.layered-image.imageName}",
            "docker run --rm ${examples.layered-image.imageName} cat extraCommands",
        )

    with subtest("Ensure images built on top of layered Docker images work"):
        docker.succeed(
            "docker load --input='${examples.layered-on-top}'",
            "docker run --rm ${examples.layered-on-top.imageName}",
        )

    with subtest("Ensure layered images built on top of layered Docker images work"):
        docker.succeed(
            "docker load --input='${examples.layered-on-top-layered}'",
            "docker run --rm ${examples.layered-on-top-layered.imageName}",
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

    with subtest("Ensure environment variables are correctly inherited"):
        docker.succeed(
            "docker load --input='${examples.environmentVariables}'"
        )
        out = docker.succeed("docker run --rm ${examples.environmentVariables.imageName} env")
        env = out.splitlines()
        assert "FROM_PARENT=true" in env, "envvars from the parent should be preserved"
        assert "FROM_CHILD=true" in env, "envvars from the child should be preserved"
        assert "LAST_LAYER=child" in env, "envvars from the child should take priority"

    with subtest("Ensure environment variables of layered images are correctly inherited"):
        docker.succeed(
            "docker load --input='${examples.environmentVariablesLayered}'"
        )
        out = docker.succeed("docker run --rm ${examples.environmentVariablesLayered.imageName} env")
        env = out.splitlines()
        assert "FROM_PARENT=true" in env, "envvars from the parent should be preserved"
        assert "FROM_CHILD=true" in env, "envvars from the child should be preserved"
        assert "LAST_LAYER=child" in env, "envvars from the child should take priority"

    with subtest(
        "Ensure inherited environment variables of layered images are correctly resolved"
    ):
        # Read environment variables as stored in image config
        config = docker.succeed(
            "tar -xOf ${examples.environmentVariablesLayered} manifest.json | ${pkgs.jq}/bin/jq -r .[].Config"
        ).strip()
        out = docker.succeed(
            f"tar -xOf ${examples.environmentVariablesLayered} {config} | ${pkgs.jq}/bin/jq -r '.config.Env | .[]'"
        )
        env = out.splitlines()
        assert (
            sum(entry.startswith("LAST_LAYER") for entry in env) == 1
        ), "envvars overridden by child should be unique"

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

    with subtest(
        "Ensure the bulk layer with a base image respects the number of maxLayers"
    ):
        docker.succeed(
            "docker load --input='${pkgs.dockerTools.examples.layered-bulk-layer}'",
            # Ensure the image runs correctly
            "docker run layered-bulk-layer ls /bin/hello",
        )

        # Ensure the image has the correct number of layers
        assert len(set_of_layers("layered-bulk-layer")) == 4

    with subtest("Ensure correct behavior when no store is needed"):
        # This check tests that buildLayeredImage can build images that don't need a store.
        docker.succeed(
            "docker load --input='${pkgs.dockerTools.examples.no-store-paths}'"
        )

        # This check may be loosened to allow an *empty* store rather than *no* store.
        docker.succeed("docker run --rm no-store-paths ls /")
        docker.fail("docker run --rm no-store-paths ls /nix/store")

    with subtest("Ensure buildLayeredImage does not change store path contents."):
        docker.succeed(
            "docker load --input='${pkgs.dockerTools.examples.filesInStore}'",
            "docker run --rm file-in-store nix-store --verify --check-contents",
            "docker run --rm file-in-store |& grep 'some data'",
        )

    with subtest("Ensure cross compiled image can be loaded and has correct arch."):
        docker.succeed(
            "docker load --input='${pkgs.dockerTools.examples.cross}'",
        )
        assert (
            docker.succeed(
                "docker inspect ${pkgs.dockerTools.examples.cross.imageName} "
                + "| ${pkgs.jq}/bin/jq -r .[].Architecture"
            ).strip()
            == "${if pkgs.system == "aarch64-linux" then "amd64" else "arm64"}"
        )

    with subtest("buildLayeredImage doesn't dereference /nix/store symlink layers"):
        docker.succeed(
            "docker load --input='${examples.layeredStoreSymlink}'",
            "docker run --rm ${examples.layeredStoreSymlink.imageName} bash -c 'test -L ${examples.layeredStoreSymlink.passthru.symlink}'",
            "docker rmi ${examples.layeredStoreSymlink.imageName}",
        )

    with subtest("buildImage supports registry/ prefix in image name"):
        docker.succeed(
            "docker load --input='${examples.prefixedImage}'"
        )
        docker.succeed(
            "docker images --format '{{.Repository}}' | grep -F '${examples.prefixedImage.imageName}'"
        )

    with subtest("buildLayeredImage supports registry/ prefix in image name"):
        docker.succeed(
            "docker load --input='${examples.prefixedLayeredImage}'"
        )
        docker.succeed(
            "docker images --format '{{.Repository}}' | grep -F '${examples.prefixedLayeredImage.imageName}'"
        )

    with subtest("buildLayeredImage supports running chown with fakeRootCommands"):
        docker.succeed(
            "docker load --input='${examples.layeredImageWithFakeRootCommands}'"
        )
        docker.succeed(
            "docker run --rm ${examples.layeredImageWithFakeRootCommands.imageName} sh -c 'stat -c '%u' /home/jane | grep -E ^1000$'"
        )
  '';
})
