import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "nar-serve";
    meta.maintainers = [ lib.maintainers.rizary ];
    nodes =
      {
        server = { pkgs, ... }: {
          services.nginx = {
            enable = true;
            virtualHosts.default.root = "/var/www";
          };
          services.nar-serve = {
            enable = true;
            # Connect to the localhost nginx instead of the default
            # https://cache.nixos.org
            cacheURL = "http://localhost/";
          };
          environment.systemPackages = [
            pkgs.hello
            pkgs.curl
          ];

          networking.firewall.allowedTCPPorts = [ 8383 ];

          # virtualisation.diskSize = 2 * 1024;
        };
      };
    testScript = ''
      import os

      start_all()

      # Create a fake cache with Nginx service the static files
      server.succeed(
          "nix --experimental-features nix-command copy --to file:///var/www ${pkgs.hello}"
      )
      server.wait_for_unit("nginx.service")
      server.wait_for_open_port(80)

      # Check that nar-serve can return the content of the derivation
      drvName = os.path.basename("${pkgs.hello}")
      drvHash = drvName.split("-")[0]
      server.wait_for_unit("nar-serve.service")
      server.succeed(
          "curl -o hello -f http://localhost:8383/nix/store/{}/bin/hello".format(drvHash)
      )
    '';
  }
)
