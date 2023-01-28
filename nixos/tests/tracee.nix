import ./make-test-python.nix ({ pkgs, ... }: {
  name = "tracee-integration";
  nodes = {
    machine = { config, pkgs, ... }: {
      # EventFilters/trace_only_events_from_new_containers requires docker
      # podman with docker compat will suffice
      virtualisation.podman.enable = true;
      virtualisation.podman.dockerCompat = true;

      environment.systemPackages = [
        # build the go integration tests as a binary
        (pkgs.tracee.overrideAttrs (oa: {
          pname = oa.pname + "-integration";
          patches = oa.patches or [] ++ [
            # change the prefix from /usr/bin to /run to find nix processes
            ../../pkgs/tools/security/tracee/test-EventFilters-prefix-nix-friendly.patch
          ];
          buildPhase = ''
            runHook preBuild
            # just build the static lib we need for the go test binary
            make $makeFlags ''${enableParallelBuilding:+-j$NIX_BUILD_CORES} bpf-core ./dist/btfhub

            # remove the /usr/bin prefix to work with the patch above
            substituteInPlace tests/integration/integration_test.go \
              --replace "/usr/bin/ls" "ls"

            # then compile the tests to be ran later
            CGO_LDFLAGS="$(pkg-config --libs libbpf)" go test -tags core,ebpf,integration -p 1 -c -o $GOPATH/tracee-integration ./tests/integration/...
            runHook postBuild
          '';
          doCheck = false;
          installPhase = ''
            mkdir -p $out/bin
            cp $GOPATH/tracee-integration $out/bin
          '';
          doInstallCheck = false;
        }))
      ];
    };
  };

  testScript = ''
    with subtest("run integration tests"):
      # EventFilters/trace_only_events_from_new_containers also requires a container called "alpine"
      machine.succeed('tar cv -C ${pkgs.pkgsStatic.busybox} . | podman import - alpine --change ENTRYPOINT=sleep')

      print(machine.succeed('TRC_BIN="${pkgs.tracee}" tracee-integration -test.v'))
  '';
})
