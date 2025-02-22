{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  fuse,
  xz,
}:

stdenv.mkDerivation rec {
  pname = "avfs";
  version = "1.2.0";
  src = fetchurl {
    url = "mirror://sourceforge/avf/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-olqOxDwe4XJiThpMec5mobkwhBzbVFtyXx7GS8q+iJw=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    fuse
    xz
  ];

  configureFlags = [
    "--enable-library"
    "--enable-fuse"
  ];

  meta = {
    homepage = "https://avf.sourceforge.net/";
    description = "Virtual filesystem that allows browsing of compressed files";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Only;
  };
}
