{ lib, mkDerivation, fetchFromGitHub
, libkiwix
, pkg-config
, qmake
, qtbase
, qtwebengine
, qtsvg
, qtimageformats
, aria2
}:

mkDerivation rec {
  pname = "kiwix";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = "${pname}-desktop";
    rev = version;
    sha256 = "sha256-ghx4pW6IkWPzZXk0TtMGeQZIzm9HEN3mR4XQFJ1xHDo=";
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
    description = "An offline reader for Web content";
    homepage = "https://kiwix.org";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ajs124 ];
  };
}
