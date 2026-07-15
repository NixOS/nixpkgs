{
  name = "pixelfed-standard";
  meta.maintainers = [ ];

  nodes = {
    server =
      { pkgs, lib, ... }:
      {
        services.pixelfed = {
          enable = true;
          domain = "pixelfed.local";
          # Configure NGINX.
          nginx = { };
          secretFile = (
            pkgs.writeText "secrets.env" ''
              # Snakeoil secret, can be any random 32-chars secret via CSPRNG.
              APP_KEY=adKK9EcY8Hcj3PLU7rzG9rJ6KKTOtYfA
            ''
          );
          settings."FORCE_HTTPS_URLS" = false;
        };

        # to prevent getting killed by oom
        virtualisation.memorySize = 2048;
        virtualisation.emptyDiskImages = [ 4096 ];
        swapDevices = [ { device = "/dev/vdb"; } ];

        # allows running nixos test on qemu without kvm, eg. github actions on aarch64-linux
        systemd.settings.Manager.DefaultDeviceTimeoutSec = lib.mkForce 1800;
        boot.initrd.kernelModules = [ "virtio_console" ];
      };
  };

  testScript = ''
    # Wait for Pixelfed PHP pool
    server.wait_for_unit("phpfpm-pixelfed.service", timeout=1800)
    # Wait for NGINX
    server.wait_for_unit("nginx.service", timeout=1800)
    # Wait for HTTP port
    server.wait_for_open_port(80, timeout=1800)
    # Access the homepage.
    server.succeed("curl -H 'Host: pixelfed.local' http://localhost")
    # Create an account
    server.succeed("pixelfed-manage user:create --name=test --username=test --email=test@test.com --password=test")
    # Create a OAuth token.
    # TODO: figure out how to use it to send a image/toot
    # server.succeed("pixelfed-manage passport:client --personal")
    # server.succeed("curl -H 'Host: pixefed.local' -H 'Accept: application/json' -H 'Authorization: Bearer secret' -F'status'='test' http://localhost/api/v1/statuses")
  '';
}
