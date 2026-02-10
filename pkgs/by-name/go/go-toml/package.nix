{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "2.2.4";
in
buildGoModule {
  pname = "go-toml";
  inherit version;

  src = fetchFromGitHub {
    owner = "pelletier";
    repo = "go-toml";
    rev = "v${version}";
    sha256 = "sha256-VKUrpSaGzkewNSyE0sB6PWVIQiraY7UxE5Wve+76UFk=";
  };

  vendorHash = null;

  excludedPackages = [
    "cmd/gotoml-test-decoder"
    "cmd/gotoml-test-encoder"
    "cmd/tomltestgen"
  ];

  # allowGoReference adds the flag `-trimpath` which is also denoted by, go-toml's goreleaser config
  #  <https://github.com/pelletier/go-toml/blob/a3d5a0bb530b5206c728eed9cb57323061922bcb/.goreleaser.yaml#L13>
  allowGoReference = true;

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
