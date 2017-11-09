{ mkDerivation, lib, fetchFromGitHub, cmake, pkgconfig,
  libtoxcore,
  libpthreadstubs, libXdmcp, libXScrnSaver,
  qtbase, qtsvg, qttools, qttranslations,
  ffmpeg, filter-audio, libexif, libsodium, libopus,
  libvpx, openal, opencv, pcre, qrencode, sqlcipher }:

mkDerivation rec {
  name = "qtox-${version}";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner  = "qTox";
    repo   = "qTox";
    rev    = "v${version}";
    sha256 = "1l1k8s10jj6nm9i33m8xhjwdhikvp7csdp6x1gxjxdj526aak8q9";
  };

  buildInputs = [
    libtoxcore
    libpthreadstubs libXdmcp libXScrnSaver
    qtbase qtsvg qttranslations
    ffmpeg filter-audio libexif libopus libsodium
    libvpx openal opencv pcre qrencode sqlcipher
  ];

  nativeBuildInputs = [ cmake pkgconfig qttools ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DGIT_DESCRIBE=${version}"
    "-DENABLE_STATUSNOTIFIER=False"
    "-DENABLE_GTK_SYSTRAY=False"
    "-DENABLE_APPINDICATOR=False"
  ];

  meta = with lib; {
    description = "Qt Tox client";
    homepage    = https://tox.chat;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ viric jgeerds akaWolf peterhoeg ];
    platforms   = platforms.all;
  };
}
