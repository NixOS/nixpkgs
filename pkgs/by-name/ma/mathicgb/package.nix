{
  fetchFromGitHub,
  lib,
  stdenv,

  autoreconfHook,
  gtest,
  mathic,
  memtailor,
  onetbb,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mathicgb";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "Macaulay2";
    repo = "mathicgb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zcHaYzznvbBkfeFXNxIxy9qlyD0esOvwUIOuEli4rwc=";
  };

  buildInputs = [
    mathic
    memtailor
    onetbb
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config # clears up bad behavior of autoconf
  ];

  checkInputs = [
    gtest
  ];

  __structuredAttrs = true;

  strictDeps = true;

  configureFlags = [
    (lib.withFeature finalAttrs.doCheck "gtest")
  ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    mainProgram = "mgb";
    description = "Program for computing Groebner basis and signature Grobner bases";
    longDescription = ''
      Mathicgb is a program for computing Groebner basis and signature Grobner
      bases. Mathicgb is based on the fast data structures from mathic.
    '';
    homepage = "https://github.com/Macaulay2/mathicgb";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ coolcuber ];
  };
})
