{ lib
, stdenv
, fetchFromSourcehut
, zig
, river
, wayland
, wayland-protocols
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "rivercarro";
  version = "0.2.1";

  src = fetchFromSourcehut {
    owner = "~novakane";
    repo = pname;
    fetchSubmodules = true;
    rev = "refs/tags/v${version}";
    hash = "sha256-lI1xU7Qw4+XmFLnFxVZvrAPMZs0SNStbcUPBqSYUBak=";
  };

  nativeBuildInputs = [
    pkg-config
    river
    wayland
    wayland-protocols
    zig
  ];

  dontConfigure = true;

  preBuild = ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    runHook preInstall
    zig build -Drelease-safe -Dcpu=baseline --prefix $out install
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://git.sr.ht/~novakane/rivercarro";
    description = "A layout generator for river Wayland compositor, fork of rivertile";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kraem ];
  };
}

