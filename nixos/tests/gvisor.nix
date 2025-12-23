# This test runs a container through gvisor and checks if simple container starts

{ pkgs, ... }:
{
  name = "gvisor";
  meta = {
    maintainers = [ ];
  };

  nodes = {
    gvisor =
      { pkgs, ... }:
      {
        virtualisation.docker = {
          enable = true;
          extraOptions = "--add-runtime runsc=${pkgs.gvisor}/bin/runsc";
        };

        networking = {
          dhcpcd.enable = false;
          defaultGateway = "192.168.1.1";
          interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
            {
              address = "192.168.1.2";
              prefixLength = 24;
            }
          ];
        };
      };
  };

  testScript = ''
    start_all()

    gvisor.wait_for_unit("network.target")
    gvisor.wait_for_unit("sockets.target")

    # Test the Docker runtime
    gvisor.succeed("tar cv --files-from /dev/null | docker import - scratchimg")
    gvisor.succeed(
        "docker run -d --name=sleeping --runtime=runsc -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg /bin/sleep 10"
    )
    gvisor.succeed("docker ps | grep sleeping")
    gvisor.succeed("docker stop sleeping")
  '';
}
