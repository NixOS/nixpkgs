{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "chroma";
  version = "2.25.0";

  src = fetchFromGitHub {
    owner = "alecthomas";
    repo = "chroma";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K2r863R1ckroKVsxMXZanxfTnMrkFtch1ZFYLUb0mMc=";
  };

  vendorHash = "sha256-lamMRKrGF0b5mfXMCsQid/UO6AyuKryJX7cKIRJho1c=";

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
