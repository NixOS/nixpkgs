{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  freetype,
  glib,
  imagemagick,
  libjpeg,
  libpng,
  libxml2,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "libwmf";
  version = "0.2.13";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "caolanm";
    repo = "libwmf";
    rev = "v${version}";
    sha256 = "sha256-vffohx57OvQKu8DfNXNBm9bPsA8KgkQWs/3mmFn7L6M=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    zlib
    imagemagick
    libpng
    glib
    freetype
    libjpeg
    libxml2
  ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "WMF library from wvWare";
    homepage = "https://wvware.sourceforge.net/libwmf.html";
    downloadPage = "https://github.com/caolanm/libwmf/releases";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
