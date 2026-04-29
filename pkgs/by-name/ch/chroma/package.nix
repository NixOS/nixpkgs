{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "chroma";
  version = "2.24.0";

  src = fetchFromGitHub {
    owner = "alecthomas";
    repo = "chroma";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KfojHrRJjGT03WeBobvBO9pHsJP6I7fSxzcSlmCsaxE=";
  };

  vendorHash = "sha256-Vq5k4Jz4r5iZs7Yy175Ubj92eSr4v1xCtbLYhfo3OAg=";

  modRoot = "./cmd/chroma";

  # substitute version info as done in goreleaser builds
  ldflags = [
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.tag}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  meta = {
    homepage = "https://github.com/alecthomas/chroma";
    description = "General purpose syntax highlighter in pure Go";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ miniharinn ];
    mainProgram = "chroma";
  };
})
