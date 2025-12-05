{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  sparrow3d,
  zlib,
}:

stdenv.mkDerivation {
  pname = "hase";
  version = "0-unstable-2020-10-06";

  src = fetchFromGitHub {
    owner = "theZiz";
    repo = "hase";
    rev = "31d6840cdf0c72fc459f10402dae7726096b2974";
    hash = "sha256-d9So3E8nCQJ1/BdlwMkGbaFPT9mkX1VzlDGKp71ptEE=";
  };

  patches = [ ./prefer-dynamic.patch ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    sparrow3d
    zlib
  ];

  buildPhase = ''
    NIX_CFLAGS_COMPILE=$(pkg-config --cflags sparrow3d zlib)

    # build and install are one step, and inseparable without patching
    mkdir -p $out/{bin,share/applications,share/pixmaps}
    ./install.sh $out
  '';

  postFixup = ''
    substituteInPlace "$out/share/applications/hase.desktop" \
      --replace "Exec=hase" "Exec=$out/bin/hase"
  '';

  meta = {
    description = "Open-source artillery shooter";
    mainProgram = "hase";
    longDescription = ''
      Hase is an open source gravity based artillery shooter. It is similar to
      Worms, Hedgewars or artillery, but the gravity force and direction
      depends on the mass nearby. It is optimized for mobile game consoles like
      the GP2X, Open Pandora or GCW Zero.
    '';
    homepage = "http://ziz.gp2x.de/hase/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ colinsane ];
    platforms = lib.platforms.linux;
  };
}
