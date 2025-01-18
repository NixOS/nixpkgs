{
  lib,
  mkDerivation,
  fetchFromGitHub,
  libkiwix,
  pkg-config,
  qmake,
  qtbase,
  qtwebengine,
  qtsvg,
  qtimageformats,
  aria2,
}:

mkDerivation {
  pname = "kiwix";
  version = "2.3.1-unstable-2024-02-20";

  src = fetchFromGitHub {
    owner = "kiwix";
    repo = "kiwix-desktop";
    rev = "17ac566b07814aefb1decf108e4ba6d7ad9ef7bc";
    hash = "sha256-BZzFnQE8/dyZkpY0X3zZ6yC6yLZ002Q/RoDzEhSOa/g=";
  };

  nativeBuildInputs = [
    qmake
    pkg-config
  ];

  buildInputs = [
    libkiwix
    qtbase
    qtwebengine
    qtsvg
    qtimageformats
  ];

  qtWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ aria2 ]}"
  ];

  meta = with lib; {
    description = "Offline reader for Web content";
    mainProgram = "kiwix-desktop";
    homepage = "https://kiwix.org";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
