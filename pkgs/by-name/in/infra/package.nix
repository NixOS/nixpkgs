{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "infra";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "infrahq";
    repo = "infra";
    rev = "v${version}";
    sha256 = "sha256-uz4wimhOfeHSL949m+biIhjfDwwEGnTiJWaz/r3Rsko=";
  };

  vendorHash = "sha256-qbmaebQcD3cN+tbmzzJbry0AXz2LZFMoqbcBwGGrRo4=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Manages access to infrastructure such as Kubernetes";
    homepage = "https://github.com/infrahq/infra";
    changelog = "https://github.com/infrahq/infra/raw/v${version}/CHANGELOG.md";
    license = lib.licenses.elastic20;
    mainProgram = "infra";
  };
}
