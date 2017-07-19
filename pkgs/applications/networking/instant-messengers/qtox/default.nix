{ mkDerivation, lib, fetchFromGitHub, cmake, pkgconfig,
  libtoxcore,
  libpthreadstubs, libXdmcp, libXScrnSaver,
  qtbase, qtsvg, qttools, qttranslations,
  atk, cairo, ffmpeg, filter-audio, gdk_pixbuf, glib, gtk2, libsodium, libopus,
  libvpx, openal, opencv, pango, pcre, qrencode, sqlcipher }:

mkDerivation rec {
  name = "qtox-${version}";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner  = "tux3";
    repo   = "qTox";
    rev    = "v${version}";
    sha256 = "0h8v359h1xn2xm6xa9q56mjiw58ap1bpiwx1dxxmphjildxadwck";
  };

  buildInputs = [
    libtoxcore
    libpthreadstubs libXdmcp libXScrnSaver
    qtbase qtsvg qttools qttranslations
    atk cairo ffmpeg filter-audio gdk_pixbuf glib gtk2 libopus libsodium
    libvpx openal opencv pango pcre qrencode sqlcipher
  ];

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
