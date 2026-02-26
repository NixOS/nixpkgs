{
  fetchFromGitHub,
  lib,
  libsForQt5,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "sasm";
  version = "3.15.0";

  src = fetchFromGitHub {
    owner = "Dman95";
    repo = "SASM";
    rev = "9993afb1fd0fedfa86225e95f03de5963ecb3c5f";
    hash = "sha256-xo65NGxSsZF7CqzR7TXOF2GOp9LiA83PvEk3hSE22Jk=";
  };

  buildInputs = [ libsForQt5.qtbase ];
  nativeBuildInputs = [ libsForQt5.wrapQtAppsHook ];

  buildPhase = ''
    qmake  "PREFIX=${placeholder "out"}/"
    make
  '';

  installPhase = ''
    make install
  '';

  meta = {
    description = "Simple crossplatform IDE for NASM, MASM, GAS, FASM assembly languages";
    homepage = "https://dman95.github.io/SASM/english.html";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ spagy ];
    platforms = lib.platforms.linux;
    mainProgram = "sasm";
  };
}
