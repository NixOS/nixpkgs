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
        images = [ k3s.airgapImages ];
      };
    };

    testScript = ''
      import json

      start_all()
      machine.wait_for_unit("k3s")
      machine.wait_until_succeeds("journalctl -r --no-pager -u k3s | grep \"Imported images from /var/lib/rancher/k3s/agent/images/\"", timeout=120)
      images = json.loads(machine.succeed("crictl img -o json"))
      image_names = [i["repoTags"][0] for i in images["images"]]
      with open("${k3s.imagesList}") as expected_images:
        for line in expected_images:
          assert line.rstrip() in image_names, f"The image {line.rstrip()} is not present in the airgap images archive"
    '';
  }
)
