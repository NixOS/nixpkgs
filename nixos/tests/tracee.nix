import ./make-test-python.nix ({ pkgs, ... }: {
  name = "tracee-integration";
  nodes = {
    machine = { config, pkgs, ... }: {
      # EventFilters/trace_only_events_from_new_containers and
      # Test_EventFilters/trace_only_events_from_"dockerd"_binary_and_contain_it's_pid
      # require docker/dockerd
      virtualisation.docker.enable = true;

      environment.systemPackages = [
        # required by Test_EventFilters/trace_events_from_ls_and_which_binary_in_separate_scopes
        pkgs.which
        # build the go integration tests as a binary
        (pkgs.tracee.overrideAttrs (oa: {
          pname = oa.pname + "-integration";
          postPatch = oa.postPatch or "" + ''
            # prepare tester.sh (which will be embedded in the test binary)
            patchShebangs tests/integration/tester.sh

            # fix the test to look at nixos paths for running programs
            substituteInPlace tests/integration/integration_test.go \
              --replace "bin=/usr/bin/" "comm=" \
              --replace "/usr/bin/dockerd" "dockerd" \
              --replace "/usr/bin" "/run/current-system/sw/bin"
          '';
          nativeBuildInputs = oa.nativeBuildInputs or [ ] ++ [ pkgs.makeWrapper ];
          buildPhase = ''
            runHook preBuild
            # just build the static lib we need for the go test binary
            make $makeFlags ''${enableParallelBuilding:+-j$NIX_BUILD_CORES} bpf-core ./dist/btfhub

            # then compile the tests to be ran later
            CGO_LDFLAGS="$(pkg-config --libs libbpf)" go test -tags core,ebpf,integration -p 1 -c -o $GOPATH/tracee-integration ./tests/integration/...
            runHook postBuild
          '';
          doCheck = false;
          installPhase = ''
            mkdir -p $out/bin
            mv $GOPATH/tracee-integration $out/bin/
          '';
          doInstallCheck = false;
        }))
      ];
    };
  };

  testScript = ''
    machine.wait_for_unit("docker.service")

    with subtest("run integration tests"):
      # EventFilters/trace_only_events_from_new_containers also requires a container called "alpine"
      machine.succeed('tar c -C ${pkgs.pkgsStatic.busybox} . | docker import - alpine --change "ENTRYPOINT [\"sleep\"]"')

      # Test_EventFilters/trace_event_set_in_a_specific_scope expects to be in a dir that includes "integration"
      print(machine.succeed(
        'mkdir /tmp/integration',
        'cd /tmp/integration && tracee-integration -test.v'
      ))
  '';
})
