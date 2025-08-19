let
  hostIp = "192.168.0.1";
  hostPort = 10080;
  containerIp = "192.168.0.100";
  containerPort = 80;
in

{ pkgs, lib, ... }:
{
  name = "containers-portforward";
  meta = {
    maintainers = with lib.maintainers; [
      aristid
      aszlig
      kampfschlaefer
      ianwookim
    ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [ ../modules/installer/cd-dvd/channel.nix ];
      virtualisation.writableStore = true;

      containers.webserver = {
        privateNetwork = true;
        hostAddress = hostIp;
        localAddress = containerIp;
        forwardPorts = [
          {
            protocol = "tcp";
            hostPort = hostPort;
            containerPort = containerPort;
          }
        ];
        config = {
          services.httpd.enable = true;
          services.httpd.adminAddr = "foo@example.org";
          networking.firewall.allowedTCPPorts = [ 80 ];
        };
      };

      virtualisation.additionalPaths = [ pkgs.stdenv ];
    };

  testScript = ''
    container_list = machine.succeed("nixos-container list")
    assert "webserver" in container_list

    # Start the webserver container.
    machine.succeed("nixos-container start webserver")

    # wait two seconds for the container to start and the network to be up
    machine.sleep(2)

    # Since "start" returns after the container has reached
    # multi-user.target, we should now be able to access it.
    # ip = machine.succeed("nixos-container show-ip webserver").strip()
    machine.succeed("ping -n -c1 ${hostIp}")
    machine.succeed("curl --fail http://${hostIp}:${toString hostPort}/ > /dev/null")

    # Stop the container.
    machine.succeed("nixos-container stop webserver")
    machine.fail("curl --fail --connect-timeout 2 http://${hostIp}:${toString hostPort}/ > /dev/null")

    # Destroying a declarative container should fail.
    machine.fail("nixos-container destroy webserver")
  '';

}
