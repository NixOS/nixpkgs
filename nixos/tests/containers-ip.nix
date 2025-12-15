let
  webserverFor = hostAddress: localAddress: {
    inherit hostAddress localAddress;
    privateNetwork = true;
    config = {
      services.httpd = {
        enable = true;
        adminAddr = "foo@example.org";
      };
      networking.firewall.allowedTCPPorts = [ 80 ];
    };
  };

in
{ pkgs, lib, ... }:
{
  name = "containers-ipv4-ipv6";
  meta = {
    maintainers = with lib.maintainers; [
      aszlig
    ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      virtualisation.writableStore = true;

      containers.webserver4 = webserverFor "10.231.136.1" "10.231.136.2";
      containers.webserver6 = webserverFor "fc00::2" "fc00::1";
      virtualisation.additionalPaths = [ pkgs.stdenv ];
    };

  testScript =
    { nodes, ... }:
    ''
      import time


      def curl_host(ip):
          # put [] around ipv6 addresses for curl
          host = ip if ":" not in ip else f"[{ip}]"
          return f"curl --fail --connect-timeout 2 http://{host}/ > /dev/null"


      def get_ip(container):
          # need to distinguish because show-ip won't work for ipv6
          if container == "webserver4":
              ip = machine.succeed(f"nixos-container show-ip {container}").rstrip()
              assert ip == "${nodes.machine.config.containers.webserver4.localAddress}"
              return ip
          return "${nodes.machine.config.containers.webserver6.localAddress}"


      for container in "webserver4", "webserver6":
          assert container in machine.succeed("nixos-container list")

          with subtest(f"Start container {container}"):
              machine.succeed(f"nixos-container start {container}")
              # wait 2s for container to start and network to be up
              time.sleep(2)

          # Since "start" returns after the container has reached
          # multi-user.target, we should now be able to access it.

          ip = get_ip(container)
          with subtest(f"{container} reacts to pings and HTTP requests"):
              machine.succeed(f"ping -n -c1 {ip}")
              machine.succeed(curl_host(ip))

          with subtest(f"Stop container {container}"):
              machine.succeed(f"nixos-container stop {container}")
              machine.fail(curl_host(ip))

          # Destroying a declarative container should fail.
          machine.fail(f"nixos-container destroy {container}")
    '';
}
