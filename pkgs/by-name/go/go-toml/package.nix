{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "2.4.3";
in
buildGoModule {
  pname = "go-toml";
  inherit version;

  src = fetchFromGitHub {
    owner = "pelletier";
    repo = "go-toml";
    rev = "v${version}";
    sha256 = "sha256-VkiNQVTUH/YnOIVPge4KVLiw/lZ4/8guS7afontAbE4=";
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
