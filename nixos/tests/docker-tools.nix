# this test creates a simple GNU image with docker tools and sees if it executes

import ./make-test-python.nix ({ pkgs, ... }:
let
  # nixpkgs#214434: dockerTools.buildImage fails to unpack base images
  # containing duplicate layers when those duplicate tarballs
  # appear under the manifest's 'Layers'. Docker can generate images
  # like this even though dockerTools does not.
  repeatedLayerTestImage =
    let
      # Rootfs diffs for layers 1 and 2 are identical (and empty)
      layer1 = pkgs.dockerTools.buildImage {  name = "empty";  };
      layer2 = layer1.overrideAttrs (_: { fromImage = layer1; });
      repeatedRootfsDiffs = pkgs.runCommandNoCC "image-with-links.tar" {
        nativeBuildInputs = [pkgs.jq];
      } ''
        mkdir contents
        tar -xf "${layer2}" -C contents
        cd contents
        first_rootfs=$(jq -r '.[0].Layers[0]' manifest.json)
        second_rootfs=$(jq -r '.[0].Layers[1]' manifest.json)
        target_rootfs=$(sha256sum "$first_rootfs" | cut -d' ' -f 1).tar

        # Replace duplicated rootfs diffs with symlinks to one tarball
        chmod -R ug+w .
        mv "$first_rootfs" "$target_rootfs"
        rm "$second_rootfs"
        ln -s "../$target_rootfs" "$first_rootfs"
        ln -s "../$target_rootfs" "$second_rootfs"

        # Update manifest's layers to use the symlinks' target
        cat manifest.json | \
        jq ".[0].Layers[0] = \"$target_rootfs\"" |
        jq ".[0].Layers[1] = \"$target_rootfs\"" > manifest.json.new
        mv manifest.json.new manifest.json

        tar --sort=name --hard-dereference -cf $out .
        '';
    in pkgs.dockerTools.buildImage {
      fromImage = repeatedRootfsDiffs;
      name = "repeated-layer-test";
      tag = "latest";
      copyToRoot = pkgs.bash;
      # A runAsRoot script is required to force previous layers to be unpacked
      runAsRoot = ''
        echo 'runAsRoot has run.'
      '';
    };

  chownTestImage =
    pkgs.dockerTools.streamLayeredImage {
      name = "chown-test";
      tag = "latest";
      enableFakechroot = true;
      fakeRootCommands = ''
        touch /testfile
        chown 12345:12345 /testfile
      '';
      config.Cmd = [ "${pkgs.coreutils}/bin/stat" "-c" "%u:%g" "/testfile" ];
    };

  nonRootTestImage =
    pkgs.dockerTools.streamLayeredImage rec {
      name = "non-root-test";
      tag = "latest";
      uid = 1000;
      gid = 1000;
      uname = "user";
      gname = "user";
      config = {
        User = "user";
        Cmd = [ "${pkgs.coreutils}/bin/stat" "-c" "%u:%g" "${pkgs.coreutils}/bin/stat" ];
      };
    };
in {
  name = "docker-tools";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ lnl7 roberth ];
  };

  nodes = {
    docker = { ... }: {
      virtualisation = {
        diskSize = 3072;
        docker.enable = true;
      };
    };
  };

  testScript = with pkgs.dockerTools; ''
    unix_time_second1 = "1970-01-01T00:00:01Z"

    docker.wait_for_unit("sockets.target")

    with subtest("includeStorePath"):
        with subtest("assumption"):
            docker.succeed("${examples.helloOnRoot} | docker load")
            docker.succeed("docker run --rm hello | grep -i hello")
            docker.succeed("docker image rm hello:latest")

        with subtest("includeStorePath = false; breaks example"):
            docker.succeed("${examples.helloOnRootNoStore} | docker load")
            docker.fail("docker run --rm hello | grep -i hello")
            docker.succeed("docker image rm hello:latest")
        with subtest("includeStorePath = false; breaks example (fakechroot)"):
            docker.succeed("${examples.helloOnRootNoStoreFakechroot} | docker load")
            docker.fail("docker run --rm hello | grep -i hello")
            docker.succeed("docker image rm hello:latest")

        with subtest("Ensure ZERO paths are added to the store"):
            docker.fail("${examples.helloOnRootNoStore} | ${pkgs.crane}/bin/crane export - - | tar t | grep 'nix/store/'")
        with subtest("Ensure ZERO paths are added to the store (fakechroot)"):
            docker.fail("${examples.helloOnRootNoStoreFakechroot} | ${pkgs.crane}/bin/crane export - - | tar t | grep 'nix/store/'")

        with subtest("includeStorePath = false; works with mounted store"):
            docker.succeed("${examples.helloOnRootNoStore} | docker load")
            docker.succeed("docker run --rm --volume ${builtins.storeDir}:${builtins.storeDir}:ro hello | grep -i hello")
            docker.succeed("docker image rm hello:latest")
        with subtest("includeStorePath = false; works with mounted store (fakechroot)"):
            docker.succeed("${examples.helloOnRootNoStoreFakechroot} | docker load")
            docker.succeed("docker run --rm --volume ${builtins.storeDir}:${builtins.storeDir}:ro hello | grep -i hello")
            docker.succeed("docker image rm hello:latest")

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
            "docker run -u somebody --rm ${examples.bashLayeredWithUser.imageName} ${pkgs.bash}/bin/bash -c 'test 755 == $(stat --format=%a /nix) && test 755 == $(stat --format=%a /nix/store)'",
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
            "docker load --input='${examples.testNixFromDockerHub}'",
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

    with subtest("Ensure layers unpacked in correct order before runAsRoot runs"):
        assert "abc" in docker.succeed(
            "docker load --input='${examples.layersUnpackOrder}'",
            "docker run --rm ${examples.layersUnpackOrder.imageName} cat /layer-order"
        )

    with subtest("Ensure repeated base layers handled by buildImage"):
        docker.succeed(
            "docker load --input='${repeatedLayerTestImage}'",
            "docker run --rm ${repeatedLayerTestImage.imageName} /bin/bash -c 'exit 0'"
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

    with subtest("Ensure only minimal paths are added to the store"):
        # TODO: make an example that has no store paths, for example by making
        #       busybox non-self-referential.

        # This check tests that buildLayeredImage can build images that don't need a store.
        docker.succeed(
            "docker load --input='${pkgs.dockerTools.examples.no-store-paths}'"
        )

        docker.succeed("docker run --rm no-store-paths ls / >/dev/console")

        # If busybox isn't self-referential, we need this line
        #   docker.fail("docker run --rm no-store-paths ls /nix/store >/dev/console")
        # However, it currently is self-referential, so we check that it is the
        # only store path.
        docker.succeed("diff <(docker run --rm no-store-paths ls /nix/store) <(basename ${pkgs.pkgsStatic.busybox}) >/dev/console")

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
            == "${if pkgs.stdenv.hostPlatform.system == "aarch64-linux" then "amd64" else "arm64"}"
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
            "docker run --rm ${examples.layeredImageWithFakeRootCommands.imageName} sh -c 'stat -c '%u' /home/alice | grep -E ^1000$'"
        )

    with subtest("Ensure docker load on merged images loads all of the constituent images"):
        docker.succeed(
            "docker load --input='${examples.mergedBashAndRedis}'"
        )
        docker.succeed(
            "docker images --format '{{.Repository}}-{{.Tag}}' | grep -F '${examples.bash.imageName}-${examples.bash.imageTag}'"
        )
        docker.succeed(
            "docker images --format '{{.Repository}}-{{.Tag}}' | grep -F '${examples.redis.imageName}-${examples.redis.imageTag}'"
        )
        docker.succeed("docker run --rm ${examples.bash.imageName} bash --version")
        docker.succeed("docker run --rm ${examples.redis.imageName} redis-cli --version")
        docker.succeed("docker rmi ${examples.bash.imageName}")
        docker.succeed("docker rmi ${examples.redis.imageName}")

    with subtest(
        "Ensure docker load on merged images loads all of the constituent images (missing tags)"
    ):
        docker.succeed(
            "docker load --input='${examples.mergedBashNoTagAndRedis}'"
        )
        docker.succeed(
            "docker images --format '{{.Repository}}-{{.Tag}}' | grep -F '${examples.bashNoTag.imageName}-${examples.bashNoTag.imageTag}'"
        )
        docker.succeed(
            "docker images --format '{{.Repository}}-{{.Tag}}' | grep -F '${examples.redis.imageName}-${examples.redis.imageTag}'"
        )
        # we need to explicitly specify the generated tag here
        docker.succeed(
            "docker run --rm ${examples.bashNoTag.imageName}:${examples.bashNoTag.imageTag} bash --version"
        )
        docker.succeed("docker run --rm ${examples.redis.imageName} redis-cli --version")
        docker.succeed("docker rmi ${examples.bashNoTag.imageName}:${examples.bashNoTag.imageTag}")
        docker.succeed("docker rmi ${examples.redis.imageName}")

    with subtest("mergeImages preserves owners of the original images"):
        docker.succeed(
            "docker load --input='${examples.mergedBashFakeRoot}'"
        )
        docker.succeed(
            "docker run --rm ${examples.layeredImageWithFakeRootCommands.imageName} sh -c 'stat -c '%u' /home/alice | grep -E ^1000$'"
        )

    with subtest("The image contains store paths referenced by the fakeRootCommands output"):
        docker.succeed(
            "docker run --rm ${examples.layeredImageWithFakeRootCommands.imageName} /hello/bin/layeredImageWithFakeRootCommands-hello"
        )

    with subtest("exportImage produces a valid tarball"):
        docker.succeed(
            "tar -tf ${examples.exportBash} | grep '\./bin/bash' > /dev/null"
        )

    with subtest("layered image fakeRootCommands with fakechroot works"):
        docker.succeed("${examples.imageViaFakeChroot} | docker load")
        docker.succeed("docker run --rm image-via-fake-chroot | grep -i hello")
        docker.succeed("docker image rm image-via-fake-chroot:latest")

    with subtest("Ensure bare paths in contents are loaded correctly"):
        docker.succeed(
            "docker load --input='${examples.build-image-with-path}'",
            "docker run --rm build-image-with-path bash -c '[[ -e /hello.txt ]]'",
            "docker rmi build-image-with-path",
        )
        docker.succeed(
            "${examples.layered-image-with-path} | docker load",
            "docker run --rm layered-image-with-path bash -c '[[ -e /hello.txt ]]'",
            "docker rmi layered-image-with-path",
        )

    with subtest("Ensure correct architecture is present in manifests."):
        docker.succeed("""
            docker load --input='${examples.build-image-with-architecture}'
            docker inspect build-image-with-architecture \
              | ${pkgs.jq}/bin/jq -er '.[] | select(.Architecture=="arm64").Architecture'
            docker rmi build-image-with-architecture
        """)
        docker.succeed("""
            ${examples.layered-image-with-architecture} | docker load
            docker inspect layered-image-with-architecture \
              | ${pkgs.jq}/bin/jq -er '.[] | select(.Architecture=="arm64").Architecture'
            docker rmi layered-image-with-architecture
        """)

    with subtest("etc"):
        docker.succeed("${examples.etc} | docker load")
        docker.succeed("docker run --rm etc | grep localhost")
        docker.succeed("docker image rm etc:latest")

    with subtest("image-with-certs"):
        docker.succeed("<${examples.image-with-certs} docker load")
        docker.succeed("docker run --rm image-with-certs:latest test -r /etc/ssl/certs/ca-bundle.crt")
        docker.succeed("docker run --rm image-with-certs:latest test -r /etc/ssl/certs/ca-certificates.crt")
        docker.succeed("docker run --rm image-with-certs:latest test -r /etc/pki/tls/certs/ca-bundle.crt")
        docker.succeed("docker image rm image-with-certs:latest")

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

    with subtest("streamLayeredImage: chown is persistent in fakeRootCommands"):
        docker.succeed(
            "${chownTestImage} | docker load",
            "docker run --rm ${chownTestImage.imageName} | diff /dev/stdin <(echo 12345:12345)"
        )

    with subtest("streamLayeredImage: with non-root user"):
        docker.succeed(
            "${nonRootTestImage} | docker load",
            "docker run --rm ${chownTestImage.imageName} | diff /dev/stdin <(echo 12345:12345)"
        )
  '';
})
