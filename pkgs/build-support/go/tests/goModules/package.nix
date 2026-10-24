{
  lib,
  testers,
  obs-cli,
  mailhog,
  scotty,
  snitch,
  talosctl,
  cloudquery,
  rdpgw,
  ...
}:

lib.recurseIntoAttrs {
  # for proxyVendor = true;
  obs-cli-proxyVendor = testers.invalidateFetcherByDrvHash (lib.const obs-cli.goModules) { };
  # deleteVendor = true;
  mailhog-deleteVendor = testers.invalidateFetcherByDrvHash (lib.const mailhog.goModules) { };
  # sets modPostBuild
  scotty-modPostBuild = testers.invalidateFetcherByDrvHash (lib.const scotty.goModules) { };
  # sets env
  snitch-env = testers.invalidateFetcherByDrvHash (lib.const snitch.goModules) { };
  # overrideModAttrs
  talosctl-overrideModAttrs = testers.invalidateFetcherByDrvHash (lib.const talosctl.goModules) { };
  # sets modRoot
  cloudquery-modRoot = testers.invalidateFetcherByDrvHash (lib.const cloudquery.goModules) { };
  # patches go.sum
  rdpgw-patch-go-sum = testers.invalidateFetcherByDrvHash (lib.const rdpgw.goModules) { };
}
