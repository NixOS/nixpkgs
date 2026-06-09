{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule {
  __structuredAttrs = true;
  pname = "prometheus-siebenmann-zfs-exporter";
  version = "unstable-2022-08-17";

  src = fetchFromGitHub {
    owner = "siebenmann";
    repo = "zfs_exporter";
    rev = "c5f18cb0d470c24dbd2c12553a87d0aca3ddc50b";
    hash = "sha256-FBFjzsoRiU48616CsxkP2lVSGO3qgLYBjOrtROzhgSY=";
  };

  vendorHash = "sha256-YjEK/nKqoMch0UygoCkk8mAclRFhsjodFVHhN49zeW4=";

  meta = {
    description = "ZFS Exporter for the Prometheus monitoring system (Siebenmann/cks-upstream variant)";
    mainProgram = "zfs_exporter";
    homepage = "https://github.com/siebenmann/zfs_exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ podocarp ];
  };
}
