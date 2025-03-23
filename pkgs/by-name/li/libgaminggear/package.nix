{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
  gettext,
  gtk2,
  libcanberra,
  libnotify,
  pcre,
  sqlite,
  xorg,
  harfbuzz,
}:

stdenv.mkDerivation rec {
  pname = "libgaminggear";
  version = "0.15.1";

  src = fetchurl {
    url = "mirror://sourceforge/libgaminggear/${pname}-${version}.tar.bz2";
    sha256 = "0jf5i1iv8j842imgiixbhwcr6qcwa93m27lzr6gb01ri5v35kggz";
  };

  outputs = [
    "dev"
    "out"
    "bin"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    gettext
  ];

  propagatedBuildInputs = [
    gtk2
    libcanberra
    libnotify
    pcre
    sqlite
    xorg.libXdmcp
    xorg.libpthreadstubs
  ];

  cmakeFlags = [
    "-DINSTALL_CMAKE_MODULESDIR=lib/cmake"
    "-DINSTALL_PKGCONFIGDIR=lib/pkgconfig"
    "-DINSTALL_LIBDIR=lib"
  ];

  # https://sourceforge.net/p/libgaminggear/discussion/general/thread/b43a776b3a/
  env.NIX_CFLAGS_COMPILE = toString [ "-I${harfbuzz.dev}/include/harfbuzz" ];

  postFixup = ''
    moveToOutput bin "$bin"
  '';

  meta = {
    description = "Provides functionality for gaming input devices";
    homepage = "https://sourceforge.net/projects/libgaminggear/";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
