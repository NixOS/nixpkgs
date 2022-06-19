{ lib, mkDerivation, fetchFromGitHub
, callPackage
, pkg-config
, makeWrapper
, qmake
, qtbase
, qtwebengine
, qtsvg
, qtimageformats
, aria2
}:

mkDerivation rec {
  pname = "kiwix";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = "${pname}-desktop";
    rev = version;
    sha256 = "sha256-ks2d/guMp5pb2tiwGxNp3htQVm65MsYvZ/6tNjGXNr8=";
  };

  nativeBuildInputs = [
    qmake
    pkg-config
  ];

  buildInputs = [
    qtbase
    qtwebengine
    qtsvg
    qtimageformats
    (callPackage ./lib.nix {})
  ];

  qtWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ aria2 ]}"
  ];

  meta = with lib; {
    description = "An offline reader for Web content";
    homepage = "https://kiwix.org";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ajs124 ];
  };
}
