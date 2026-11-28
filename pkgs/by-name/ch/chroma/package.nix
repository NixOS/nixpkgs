{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "chroma";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "alecthomas";
    repo = "chroma";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r7K0bjr7g4ljATKioj1QApPyoUS+L2w5pWNu25pyDos=";
  };

  vendorHash = "sha256-diejMB2Li7R/Uuhm/kd8+OcQHHqdAOdZe3FPVbjWl3U=";

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
