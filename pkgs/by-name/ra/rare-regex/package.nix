{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  withPcre2 ? stdenv.hostPlatform.isLinux,
  pcre2,
  testers,
  rare-regex,
}:

buildGoModule (finalAttrs: {
  pname = "rare";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "zix99";
    repo = "rare";
    tag = finalAttrs.version;
    hash = "sha256-tzAbt9THSTYDvooU7yNQJhJaFM1bcKCabDNtiMpux3Q=";
  };

  vendorHash = "sha256-wUOtxNjL/4MosACCzPTWKWrnMZhxINfN1ppkRsqDh9M=";

  buildInputs = lib.optionals withPcre2 [
    pcre2
  ];

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.buildSha=${finalAttrs.src.tag}"
  ];

  # Skip tests try /dev.
  checkFlags = [
    "-skip=TestNoMountTraverseWithSymlink"
  ];

  tags = lib.optionals withPcre2 [
    "pcre2"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = rare-regex;
    };
  };

  meta = {
    description = "Fast text scanner/regex extractor and realtime summarizer";
    homepage = "https://rare.zdyn.net";
    maintainers = with lib.maintainers; [ liberodark ];
    changelog = "https://github.com/zix99/rare/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "rare";
  };
})
