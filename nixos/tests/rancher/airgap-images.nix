# A test that imports k3s airgapped images and verifies that all expected images are present
import ../make-test-python.nix (
  {
    lib,
    rancherDistro,
    rancherPackage,
    serviceName,
    disabledComponents,
    ...
  }:
  {
    name = "${rancherPackage.name}-airgap-images";
    meta.maintainers = lib.teams.k3s.members;

    nodes.machine = _: {
      # k3s uses enough resources the default vm fails.
      virtualisation.memorySize = 1536;
      virtualisation.diskSize = 4096;

      services.${rancherDistro} = {
        enable = true;
        role = "server";
        package = rancherPackage;
        disable = disabledComponents;
        images =
          {
            k3s = [ rancherPackage.airgap-images ];
          }
          .${rancherDistro};
      };
    };

    testScript = ''
      machine.wait_for_unit("${serviceName}")
      machine.wait_until_succeeds("journalctl -r --no-pager -u ${serviceName} | grep \"Imported images from /var/lib/rancher/${rancherDistro}/agent/images/\"")
    '';
  }
)
