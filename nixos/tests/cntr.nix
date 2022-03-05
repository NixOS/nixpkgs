# Test for cntr tool
{ system ? builtins.currentSystem, config ? { }
, pkgs ? import ../.. { inherit system config; }, lib ? pkgs.lib }:

let
  inherit (import ../lib/testing-python.nix { inherit system pkgs; }) makeTest;

  mkOCITest = backend:
    makeTest {
      name = "cntr-${backend}";

      meta = { maintainers = with lib.maintainers; [ sorki mic92 ]; };

      nodes = {
        ${backend} = { pkgs, ... }: {
          environment.systemPackages = [ pkgs.cntr ];
          virtualisation.oci-containers = {
            inherit backend;
            containers.nginx = {
              image = "nginx-container";
              imageFile = pkgs.dockerTools.examples.nginx;
              ports = [ "8181:80" ];
            };
          };
        };
      };

      testScript = ''
        start_all()
        ${backend}.wait_for_unit("${backend}-nginx.service")
        ${backend}.wait_for_open_port(8181)
        # For some reason, the cntr command hangs when run without the &.
        # As such, we have to do some messy things to ensure we check the exitcode and output in a race-condition-safe manner
        ${backend}.execute(
            "(cntr attach -t ${backend} nginx sh -- -c 'curl localhost | grep Hello' > /tmp/result; echo $? > /tmp/exitcode; touch /tmp/done) &"
        )

        ${backend}.wait_for_file("/tmp/done")
        assert "0" == ${backend}.succeed("cat /tmp/exitcode").strip(), "non-zero exit code"
        assert "Hello" in ${backend}.succeed("cat /tmp/result"), "no greeting in output"
      '';
    };

  mkContainersTest = makeTest {
    name = "cntr-containers";

    meta = with pkgs.lib.maintainers; { maintainers = [ sorki mic92 ]; };

    machine = { lib, ... }: {
      environment.systemPackages = [ pkgs.cntr ];
      containers.test = {
        autoStart = true;
        privateNetwork = true;
        hostAddress = "172.16.0.1";
        localAddress = "172.16.0.2";
        config = { };
      };
    };

    testScript = ''
      machine.start()
      machine.wait_for_unit("container@test.service")
      # I haven't observed the same hanging behaviour in this version as in the OCI version which necessetates this messy invocation, but it's probably better to be safe than sorry and use it here as well
      machine.execute(
          "(cntr attach test sh -- -c 'ping -c5 172.16.0.1'; echo $? > /tmp/exitcode; touch /tmp/done) &"
      )

      machine.wait_for_file("/tmp/done")
      assert "0" == machine.succeed("cat /tmp/exitcode").strip(), "non-zero exit code"
    '';
  };
in {
  nixos-container = mkContainersTest;
} // (lib.foldl' (attrs: backend: attrs // { ${backend} = mkOCITest backend; })
  { } [ "docker" "podman" ])
