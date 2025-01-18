{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gama-tui";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "termkit";
    repo = "gama";
    tag = "v${version}";
    hash = "sha256-ZMM+Nt/9Bqmx7kzlhZM8I++BYZhwilRjNXSTAmOrxk4=";
  };

  vendorHash = "sha256-PTyrSXLMr244+ZTvjBBUc1gmwYXBAs0bXZS2t3aSWFQ=";

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
