{ mkDerivation, lib, fetchFromGitHub, cmake, pkgconfig, openal, opencv,
  libtoxcore, libsodium, libXScrnSaver, glib, gdk_pixbuf, gtk2, cairo, xorg,
  pango, atk, qrencode, ffmpeg, filter-audio,
  qtbase, qtsvg, qttools, qttranslations, sqlcipher,
  libvpx, libopus }:

mkDerivation rec {
  name = "qtox-${version}";
  version = "1.10.2";

  src = fetchFromGitHub {
    owner  = "tux3";
    repo   = "qTox";
    rev    = "v${version}";
    sha256 = "0c2633rc9l73q9qs9hybn11hmlqbwsvih3sf6jk1jp4151k5wp1y";
  };

  buildInputs = [
    libtoxcore openal opencv libsodium filter-audio
    qtbase qttools qtsvg libXScrnSaver glib gtk2 cairo
    pango atk qrencode ffmpeg qttranslations
    sqlcipher
    libopus libvpx
  ] ++ (with xorg; [
    libpthreadstubs libXdmcp
  ]);

  nativeBuildInputs = [ cmake pkgconfig ];

  cmakeFlags = [
    "-DGIT_DESCRIBE=${version}"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 qtox $out/bin/qtox

    runHook postInstall
  '';

  meta = with lib; {
    description = "Qt Tox client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ viric jgeerds akaWolf peterhoeg ];
    platforms = platforms.all;
  };
}
