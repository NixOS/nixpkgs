# Test for cntr tool

{ runTest, lib }:

let
  mkOCITest =
    backend:
    runTest {
      name = "cntr-${backend}";

      meta.maintainers = with lib.maintainers; [
        sorki
        mic92
      ];

      nodes.${backend} =
        { pkgs, ... }:
        {
          environment.systemPackages = [ pkgs.cntr ];
          virtualisation.oci-containers = {
            inherit backend;
            containers.nginx = {
              image = "nginx-container";
              imageStream = pkgs.dockerTools.examples.nginxStream;
              ports = [ "8181:80" ];
            };
          };
        };

      testScript = ''
        start_all()
        ${backend}.wait_for_unit("${backend}-nginx.service")
        ${backend}.wait_for_open_port(8181)
        # Test attach: uses host tools in container's network namespace
        # Curl localhost to verify we're in the container's network
        result = ${backend}.succeed("cntr attach -t ${backend} nginx curl -s localhost")
        assert "Hello" in result, f"no greeting in output: {result}"
        # Test exec: runs in container's native filesystem
        # Use nginx's own binary to verify exec works
        result = ${backend}.succeed("cntr exec -t ${backend} nginx -- nginx -v")
        assert "nginx" in result, f"expected nginx version: {result}"
      '';
    };

  mkContainersTest = runTest {
    name = "cntr-containers";

    meta.maintainers = with lib.maintainers; [
      sorki
      mic92
    ];

    nodes.machine =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.cntr ];
        containers.test = {
          autoStart = true;
          privateNetwork = true;
          hostAddress = "172.16.0.1";
          localAddress = "172.16.0.2";
          config =
            { pkgs, ... }:
            {
              environment.systemPackages = [ pkgs.iputils ];
            };
        };
      };

    testScript = ''
      machine.start()
      machine.wait_for_unit("container@test.service")
      # Test attach: container fs is mounted at /var/lib/cntr/
      # Writing to /var/lib/cntr/tmp/foo creates /tmp/foo in the container
      machine.succeed("cntr attach test touch /var/lib/cntr/tmp/cntr-attach-test")
      # Verify both that exec works and that the file from attach exists in container's /tmp
      machine.succeed("cntr exec test -- test -f /tmp/cntr-attach-test")
      machine.succeed("cntr exec test -- /run/current-system/sw/bin/ping -c1 172.16.0.1")
    '';
  };
in
{
  nixos-container = mkContainersTest;
}
// (lib.genAttrs [ "docker" "podman" ] mkOCITest)
