{ mkDerivation, lib, fetchFromGitHub, cmake, pkgconfig,
  libtoxcore,
  libpthreadstubs, libXdmcp, libXScrnSaver,
  qtbase, qtsvg, qttools, qttranslations,
  ffmpeg, filter-audio, libsodium, libopus,
  libvpx, openal, opencv, pcre, qrencode, sqlcipher }:

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
    ffmpeg filter-audio libopus libsodium
    libvpx openal opencv pcre qrencode sqlcipher
  ];

  nativeBuildInputs = [ cmake pkgconfig ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DGIT_DESCRIBE=${version}"
    "-DENABLE_STATUSNOTIFIER=False"
    "-DENABLE_GTK_SYSTRAY=False"
    "-DENABLE_APPINDICATOR=False"
  ];

  meta = with lib; {
    description = "Qt Tox client";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ viric jgeerds akaWolf peterhoeg ];
    platforms   = platforms.all;
  };
}
