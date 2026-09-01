{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "QtRVSim";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "cvut";
    repo = "qtrvsim";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-+EpPDA2+mBTdQjq6i9TN11yeXqvJA28JtmdNihM1a/U=";
  };

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [ libsForQt5.qtbase ];

  meta = {
    description = "RISC-V CPU simulator for education purposes";
    longDescription = ''
      RISC-V CPU simulator for education purposes with pipeline and cache visualization.
      Developed at FEE CTU for computer architecture classes.
    '';
    homepage = "https://github.com/cvut/qtrvsim";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ jdupak ];
    mainProgram = "qtrvsim_gui";
  };
})
