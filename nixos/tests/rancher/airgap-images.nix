# A test that imports k3s airgapped images and verifies that all expected images are present
{
  pkgs,
  lib,
  rancherDistro,
  rancherPackage,
  serviceName,
  disabledComponents,
  coreImages,
  vmResources,
  ...
}:
{
  name = "${rancherPackage.name}-airgap-images";

  nodes.machine = _: {
    virtualisation = vmResources;

    services.${rancherDistro} = {
      enable = true;
      role = "server";
      package = rancherPackage;
      disable = disabledComponents;
      images =
        coreImages
        ++ {
          k3s = [ rancherPackage.airgap-images ];
          rke2 = [ ]; # RKE2 already includes its airgap-images in coreImages
        }
        .${rancherDistro};
    };
  };

  testScript = ''
    machine.wait_for_unit("${serviceName}")
    machine.wait_until_succeeds("journalctl -r --no-pager -u ${serviceName} | grep \"Imported images from /var/lib/rancher/${rancherDistro}/agent/images/\"")
  '';

  meta.maintainers = lib.teams.k3s.members ++ pkgs.rke2.meta.maintainers;
}
