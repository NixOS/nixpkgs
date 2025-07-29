{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  srcInfo = lib.importJSON ./src.json;
in

buildGoModule rec {
  pname = "chroma";
  version = "2.19.0";

  # To update:
  # nix-prefetch-git --rev v${version} https://github.com/alecthomas/chroma.git > src.json
  src = fetchFromGitHub {
    owner = "alecthomas";
    repo = "chroma";
    rev = "v${version}";
    inherit (srcInfo) sha256;
  };

  vendorHash = "sha256-Gqldcp68Rn4wkfQptbmKUjkwLSb+qaFboJNfmWVkrPU=";

  modRoot = "./cmd/chroma";

  # substitute version info as done in goreleaser builds
  ldflags = [
    "-X"
    "main.version=${version}"
    "-X"
    "main.commit=${srcInfo.rev}"
    "-X"
    "main.date=${srcInfo.date}"
  ];

  meta = with lib; {
    homepage = "https://github.com/alecthomas/chroma";
    description = "General purpose syntax highlighter in pure Go";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
    mainProgram = "chroma";
  };
}
