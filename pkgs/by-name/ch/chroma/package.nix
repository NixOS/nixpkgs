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
  version = "2.15.0";

  # To update:
  # nix-prefetch-git --rev v${version} https://github.com/alecthomas/chroma.git > src.json
  src = fetchFromGitHub {
    owner = "alecthomas";
    repo = pname;
    rev = "v${version}";
    inherit (srcInfo) sha256;
  };

  vendorHash = "sha256:14jg809xz647yv6sc8rnnksg2bpnn75panj8a2kdk2v87yrpq2zr";

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
