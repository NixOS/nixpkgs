{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  isa-l,
  zlib,
}:
stdenv.mkDerivation (self: {
  pname = "strobealign";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "ksahlin";
    repo = "strobealign";
    tag = "v${self.version}";
    hash = "sha256-RZxIT6iwanRuPk2sWv/QRkUaPMdterOKCo30FPZHC8o=";
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
