{
  stdenv,
  fetchFromGitHub,
  qt5,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qgo";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "johndaniels";
    repo = "qgo";
    tag = "${finalAttrs.version}";
    hash = "sha256-pW9QdHhOtih8gBIakqCdSjThpnYZo/2dmciLTH09+1A=";
  };

  patches = [ ./fix-paths.patch ];

  postPatch = ''
    sed -i 's|@out@|'"''${out}"'|g' src/src.pro src/defines.h
  '';

  qmakeFlags = [ "src/src.pro" ];

  nativeBuildInputs = [
    qt5.qmake
    qt5.qttools
    qt5.wrapQtAppsHook
  ];
  buildInputs = [
    qt5.qtbase
    qt5.qtmultimedia
  ];

  meta = {
    description = "Go client based on Qt5";
    longDescription = ''
      qGo is a Go Client based on Qt 5. It supports playing online at
      IGS-compatible servers (including some special tweaks for WING and LGS,
      also NNGS was reported to work) and locally against gnugo (or other
      GTP-compliant engines). It also has rudimentary support for editing SGF
      files and parital support for CyberORO/WBaduk, Tygem, Tom, and eWeiqi
      (developers of these backends are currently inactive, everybody is welcome
      to take them over).

      Go is an ancient Chinese board game. It's called "圍棋(Wei Qi)" in
      Chinese, "囲碁(Yi Go)" in Japanese, "바둑(Baduk)" in Korean.
    '';
    homepage = "https://github.com/johndaniels/qgo";
    mainProgram = "qgo";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ zalakain ];
    platforms = lib.platforms.linux;
  };
})
