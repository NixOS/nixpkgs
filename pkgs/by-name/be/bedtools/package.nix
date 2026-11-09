{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  python3,
  bzip2,
  xz,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bedtools";
  version = "2.31.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "arq5x";
    repo = "bedtools2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rrk+FSv1bGL0D1lrIOsQu2AT7cw2T4lkDiCnzil5fpg=";
  };

  nativeBuildInputs = [
    python3
  ];

  buildInputs = [
    zlib
    bzip2
    xz
  ];

  enableParallelBuilding = true;

  makeFlags = [
    "prefix=${placeholder "out"}"
    # The Makefiles hardcode `CC = gcc` and `CXX = g++`.
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Powerful toolset for genome arithmetic";
    homepage = "https://bedtools.readthedocs.io/en/latest/";
    downloadPage = "https://github.com/arq5x/bedtools2";
    changelog = "https://github.com/arq5x/bedtools2/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "bedtools";
    maintainers = with lib.maintainers; [ jbedo ];
    platforms = lib.platforms.unix;
  };
})
