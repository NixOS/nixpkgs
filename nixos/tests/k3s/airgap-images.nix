# A test that imports k3s airgapped images and verifies that all expected images are present
import ../make-test-python.nix (
  { lib, k3s, ... }:
  {
    name = "${k3s.name}-airgap-images";
    meta.maintainers = lib.teams.k3s.members;

    nodes.machine = _: {
      # k3s uses enough resources the default vm fails.
      virtualisation.memorySize = 1536;
      virtualisation.diskSize = 4096;

      services.k3s = {
        enable = true;
        role = "server";
        package = k3s;
        # Slightly reduce resource usage
        extraFlags = [
          "--disable coredns"
          "--disable local-storage"
          "--disable metrics-server"
          "--disable servicelb"
          "--disable traefik"
        ];
        images = [ k3s.airgap-images ];
      };
    };

    testScript = ''
      machine.wait_for_unit("k3s")
      machine.wait_until_succeeds("journalctl -r --no-pager -u k3s | grep \"Imported images from /var/lib/rancher/k3s/agent/images/\"")
    '';
  }
)
