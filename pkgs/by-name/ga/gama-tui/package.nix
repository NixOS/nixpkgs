{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gama-tui";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "termkit";
    repo = "gama";
    tag = "v${version}";
    hash = "sha256-laE3lW2MX3vYxsF5iHl0sLKCAPRAIZGQs72+vdbX4t0=";
  };

  vendorHash = "sha256-rx18df0iiYqQToydXcA6Kqsn3lePIL1RNMSvD+a4WrI=";

  ldflags = [
    "-s"
    "-X main.Version=v${version}"
  ];

  # requires network access
  doCheck = false;

  meta = {
    description = "Manage your GitHub Actions from Terminal with great UI";
    homepage = "https://github.com/termkit/gama";
    changelog = "https://github.com/termkit/gama/releases";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "gama";
  };
}
