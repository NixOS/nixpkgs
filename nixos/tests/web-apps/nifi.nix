import ../make-test-python.nix ({pkgs, ...}:
{
  name = "nifi";
  meta.maintainers = with pkgs.lib.maintainers; [ izorkin ];

  nodes = {
    nifi = { pkgs, ... }: {
      virtualisation = {
        memorySize = 2048;
        diskSize = 4096;
      };
      services.nifi = {
        enable = true;
        enableHTTPS = false;
      };
    };
  };

  testScript = ''
    nifi.start()

    nifi.wait_for_unit("nifi.service")
    nifi.wait_for_open_port(8080)

    # Check if NiFi is running
    nifi.succeed("curl --fail http://127.0.0.1:8080/nifi/login 2> /dev/null | grep 'NiFi Login'")

    nifi.shutdown()
  '';
})
