{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  isa-l,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "strobealign";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "ksahlin";
    repo = "strobealign";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ah21ptyfZbgdJrtCCftYhGh1hfcJ9JpXNsXUp8pZDJw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    zlib
    isa-l
  ];

  meta = {
    description = "Read aligner for short reads";
    mainProgram = "strobealign";
    license = lib.licenses.mit;
    homepage = "https://github.com/ksahlin/strobealign";
    maintainers = [ lib.maintainers.jbedo ];
    platforms = lib.platforms.unix;
  };
})
