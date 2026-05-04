{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  gpgme,
  libassuan,
  systemd,
  withBtrfs ? true,
  btrfs-progs,
}:
buildGoModule (finalAttrs: {
  pname = "prometheus-podman-exporter";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "prometheus-podman-exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HY9ZOooAlIF3vb7ZENpRGvW5074PQS8yrfFXG39/Ycw=";
  };

  buildInputs = [
    gpgme
    libassuan
    systemd
  ]
  ++ lib.optional withBtrfs btrfs-progs;
  nativeBuildInputs = [ pkg-config ];

  # NOTE: this is mostly just copied from the Makefile + the scripts in hack/
  # The .spec file in rpm/ also contains some useful information in the %build section
  tags = [
    "remote"
    "containers_image_openpgp"
    "systemd"
  ]
  ++ lib.optionals (!withBtrfs) [
    "exclude_graphdriver_btrfs"
    "btrfs_noversion"
  ];

  ldflags = [
    # NOTE: upstream manually defines this in a VERSION file
    "-X github.com/containers/prometheus-podman-exporter/cmd.buildVersion=${finalAttrs.version}"
    "-X github.com/containers/prometheus-podman-exporter/cmd.buildRevision=${lib.versions.major finalAttrs.version}"
    # this should be the git ref, for tags it is HEAD
    "-X github.com/containers/prometheus-podman-exporter/cmd.buildBranch=HEAD"
  ];

  vendorHash = null;

  __structuredAttrs = true;

  # NOTE: requires a running podman daemon and a $HOME in scripts
  doCheck = false;

  meta = {
    description = "Prometheus exporter for podman environments exposing containers, pods, images, volumes and networks information";
    homepage = "https://github.com/containers/prometheus-podman-exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cobalt ];
    mainProgram = "prometheus-podman-exporter";
  };
})
