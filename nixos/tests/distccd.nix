{
  pkgs,
  lib,
  containers,
  ...
}:
{
  name = "distccd";
  meta.maintainers = [ lib.maintainers.h7x4 ];

  containers = {
    server =
      { containers, ... }:
      {
        services.distccd = {
          enable = true;
          allowedClients = [ containers.client.networking.primaryIPAddress ];
          logLevel = "info";
          openFirewall = true;
        };
      };

    client =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          distcc
          gcc
        ];

        environment.variables = {
          DISTCC_HOSTS = "server";
          # Don't compile locally
          DISTCC_FALLBACK = "0";
        };
      };
  };

  testScript =
    let
      hello = pkgs.writeText "hello.c" ''
        #include <stdio.h>

        int main(void) {
          printf("hello from distcc\n");
          return 0;
        }
      '';
    in
    ''
      start_all()

      server.wait_for_unit("distccd.service")
      server.wait_for_open_port(3632)

      client.systemctl("start network-online.target")
      client.wait_for_unit("network-online.target")
      client.succeed("ping -n -c 1 server")

      with subtest("Compile a C program on the client, offloading to the server"):
          client.succeed("cd /tmp && distcc gcc -c ${hello} -o hello.o")
          client.succeed("cd /tmp && gcc hello.o -o hello && ./hello")

      with subtest("Verify with server logs that it ran the compilation"):
          journal = server.succeed("journalctl -u distccd --no-pager")
          assert "COMPILE_OK" in journal, f"distccd did not report a successful compile:\n{journal}"
          assert (
              "${containers.client.networking.primaryIPAddress}" in journal
          ), f"distccd did not serve the client:\n{journal}"
    '';
}
