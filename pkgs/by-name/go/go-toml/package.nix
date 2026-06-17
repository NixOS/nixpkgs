{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "2.4.0";
in
buildGoModule {
  pname = "go-toml";
  inherit version;

  src = fetchFromGitHub {
    owner = "pelletier";
    repo = "go-toml";
    rev = "v${version}";
    sha256 = "sha256-AJ8FVmMjE7Q2UYlOr9z+mcWuxQI+YE1AO5P7Vderkfs=";
  };

  vendorHash = null;

  excludedPackages = [
    "cmd/gotoml-test-decoder"
    "cmd/gotoml-test-encoder"
    "cmd/tomltestgen"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = {
    description = "Go library for the TOML language";
    homepage = "https://github.com/pelletier/go-toml";
    changelog = "https://github.com/pelletier/go-toml/releases/tag/v${version}";
    maintainers = [ lib.maintainers.isabelroses ];
    license = lib.licenses.mit;
  };
}
