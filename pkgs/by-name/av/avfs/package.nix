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
  version = "1.1.5";
  src = fetchurl {
    url = "mirror://sourceforge/avf/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-rZ87ZBBNYAmgWMcPZwiPeZMJv4UZsUsVSvrSJqRScs8=";
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

  meta = with lib; {
    homepage = "https://avf.sourceforge.net/";
    description = "Virtual filesystem that allows browsing of compressed files";
    platforms = platforms.unix;
    license = licenses.gpl2Only;
  };
}
