{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libsForQt5,
}:

stdenv.mkDerivation rec {
  pname = "QtRVSim";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "cvut";
    repo = "qtrvsim";
    tag = "v${version}";
    sha256 = "sha256-+EpPDA2+mBTdQjq6i9TN11yeXqvJA28JtmdNihM1a/U=";
  };

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [ libsForQt5.qtbase ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "RISC-V CPU simulator for education purposes";
    longDescription = ''
      RISC-V CPU simulator for education purposes with pipeline and cache visualization.
      Developed at FEE CTU for computer architecture classes.
    '';
    homepage = "https://github.com/cvut/qtrvsim";
<<<<<<< HEAD
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ jdupak ];
=======
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ jdupak ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "qtrvsim_gui";
  };
}
