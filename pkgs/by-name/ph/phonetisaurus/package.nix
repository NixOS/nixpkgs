{
  lib,
  stdenv,
  fetchFromGitHub,
  openfst,
  pkg-config,
  python3,
}:

stdenv.mkDerivation {
  pname = "phonetisaurus";
  version = "0.9.1-unstable-2026-01-05";

  src = fetchFromGitHub {
    owner = "danijel3";
    repo = "Phonetisaurus";
    tag = "kaldi";
    sha256 = "sha256-dPAVasGSD2j8xmUQsWE0tjAXvCBNOuXLq+ayttA5r2Q=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    python3
    openfst
  ];

  meta = {
    description = "Framework for Grapheme-to-phoneme models for speech recognition using the OpenFst framework";
    homepage = "https://github.com/AdolfVonKleist/Phonetisaurus";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mic92 ];
    platforms = lib.platforms.unix;
  };
}
