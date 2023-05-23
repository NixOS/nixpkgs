import ./make-test-python.nix ({lib, pkgs, ...}:
{
  name = "nginx-media-types";
  meta.maintainers = with pkgs.lib.maintainers; [ izorkin ];

  nodes = {
    machine = { pkgs, ... }: {
      services.nginx = {
        enable = true;
        defaultMimeTypes = "${pkgs.media-types}/etc/nginx/mime.types";
      };
    };
  };

  testScript = ''
    machine.start()

    machine.wait_for_unit("nginx")

    # Checking for duplicate media.types
    machine.fail("journalctl --unit nginx --grep 'duplicate extension'")

    machine.shutdown()
  '';
})
