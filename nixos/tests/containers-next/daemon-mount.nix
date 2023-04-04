import ../make-test-python.nix ({ pkgs, lib, ... }: {
  name = "containers-next-daemon-mount";
  meta.maintainers = with lib.maintainers; [ ma27 ];

  nodes = {
    machine = {
      networking.useNetworkd = true;
      nixos.containers.instances.container0 = {
        network = {};
        mountDaemonSocket = true;
        system-config = { pkgs, ... }: {
          environment.systemPackages = [
            (pkgs.writeShellScriptBin "run-build" ''
              set -ex
              nix-build ${pkgs.writeText "test.nix" ''
                builtins.derivation {
                  name = "trivial";
                  system = "${pkgs.stdenv.hostPlatform.system}";
                  builder = "/bin/sh";
                  allowSubstitutes = false;
                  preferLocalBuild = true;
                  args = ["-c" "echo success > $out; exit 0"];
                }
              ''}

              test -f result
              grep success result
            '')
          ];
        };
      };
    };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("machines.target")

    machine.succeed(
      "systemd-run -M container0 --pty --quiet -- /bin/sh --login -c 'run-build'"
    )

    machine.shutdown()
  '';
})
