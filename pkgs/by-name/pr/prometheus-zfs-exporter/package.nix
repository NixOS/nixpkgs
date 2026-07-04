{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "zfs_exporter";
  version = "2.3.12";

  src = fetchFromGitHub {
    owner = "pdf";
    repo = "zfs_exporter";
    rev = "v" + version;
    hash = "sha256-4nuZhPqBqGOR5zM1yyxPD0M4bVZNaIm72uSus6CvCrU=";
  };

  vendorHash = "sha256-8AUo6sfdKME5x89CvabMDxBOzq3f/+//du/+N+cvpWA=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${version}"
    "-X github.com/prometheus/common/version.Revision=unknown"
    "-X github.com/prometheus/common/version.Branch=unknown"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
    "-X github.com/prometheus/common/version.BuildDate=unknown"
  ];

  postInstall = ''
    install -Dm444 -t $out/share/doc/zfs_exporter *.md
  '';

  meta = {
    description = "ZFS Exporter for the Prometheus monitoring system";
    mainProgram = "zfs_exporter";
    homepage = "https://github.com/pdf/zfs_exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
