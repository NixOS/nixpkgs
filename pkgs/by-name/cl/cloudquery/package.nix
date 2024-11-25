{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cloudquery";
  version = "6.11.2";

  src = fetchFromGitHub {
    owner = "cloudquery";
    repo = "cloudquery";
    rev = "refs/tags/cli-v${version}";
    hash = "sha256-zVzHPAN/UAVQF56qcoIFOqtX/Aek3+1lO2O965UYxPM=";
  };

  vendorHash = "sha256-9YvsVflHr4QSVCYCcWg1Okmncc1sNteMJEAdz92BIgI=";

  CGO_ENABLED = 0;

  modRoot = "cli";

  # Some checks fail to download deps
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/cloudquery/cloudquery/cli/cmd.Version=${version}"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/cloudquery
    rm $out/bin/gen
  '';

  meta = {
    description = "Data movement tool to sync data from any source to any destination";
    mainProgram = "cloudquery";
    longDescription = ''
      CloudQuery is a versatile open-source data movement tool built for developers
      that allows you to sync data from any source to any destination.
    '';
    homepage = "https://www.cloudquery.io";
    changelog = "https://github.com/cloudquery/cloudquery/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      mrgiles
    ];
  };
}
