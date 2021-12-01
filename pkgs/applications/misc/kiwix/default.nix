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
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = "${pname}-desktop";
    rev = version;
    sha256 = "12v43bcg4g8fcp02y2srsfdvcb7dpl4pxb9z7a235006s0kfv8yn";
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
