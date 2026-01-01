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
<<<<<<< HEAD
  version = "0.17.0";
=======
  version = "0.16.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ksahlin";
    repo = "strobealign";
    tag = "v${self.version}";
<<<<<<< HEAD
    hash = "sha256-ah21ptyfZbgdJrtCCftYhGh1hfcJ9JpXNsXUp8pZDJw=";
=======
    hash = "sha256-RZxIT6iwanRuPk2sWv/QRkUaPMdterOKCo30FPZHC8o=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
