{ lib
, stdenv
, fetchFromSourcehut
, wayland
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "stacktile";
  version = "1.0.0";

  src = fetchFromSourcehut {
    owner = "~leon_plickat";
    repo = pname;
    fetchSubmodules = true;
    rev = "v${version}";
    sha256 = "sha256-IOFxgYMjh92jx2CPfBRZDL/1ucgfHtUyAL5rS2EG+Gc=";
  };

  nativeBuildInputs = [
    pkg-config
    wayland
  ];

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
  ];

  meta = with lib; {
    homepage = "https://sr.ht/~leon_plickat/stacktile";
    description = "A layout generator for river Wayland compositor";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ edrex ];
  };
}

