{ lib
, mkDerivation
, makeDesktopItem
, fetchFromGitLab
, qmake
# qt
, qtbase
, qtwebsockets
}:

let
  desktopItem = makeDesktopItem {
    name = "Michabo";
    desktopName = "Michabo";
    exec = "Michabo";
  };

in mkDerivation rec {
  pname = "michabo";
  version = "0.1";

  src = fetchFromGitLab {
    domain = "git.pleroma.social";
    owner = "kaniini";
    repo = "michabo";
    rev = "v${version}";
    sha256 = "0pl4ymdb36r0kwlclfjjp6b1qml3fm9ql7ag5inprny5y8vcjpzn";
  };

  nativeBuildInputs = [
    qmake
  ];
  buildInputs = [
    qtbase
    qtwebsockets
  ];

  qmakeFlags = [ "michabo.pro" "DESTDIR=${placeholder "out"}/bin" ];

  postInstall = ''
    ln -s ${desktopItem}/share $out/share
  '';

  meta = with lib; {
    description = "A native desktop app for Pleroma and Mastodon servers";
    homepage = "https://git.pleroma.social/kaniini/michabo";
    license = licenses.gpl3;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}

