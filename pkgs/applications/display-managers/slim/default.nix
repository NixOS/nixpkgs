{ stdenv, fetchFromGitHub, pkgconfig, cmake
, libjpeg, libpng, fontconfig, freetype, pam, dbus, xorg }:

stdenv.mkDerivation rec {
  pname = "slim-ng";
  version = "1.3.8";

  src = fetchFromGitHub {
    owner = "oxij";
    repo = pname;
    rev = "v${version}";
    sha256 = "0jkq351shkjb0jz9f0jvi3v60yyjkp6n9fmimqq4f21cax45lsrd";
  };

  cmakeFlags = [ "-DUSE_PAM=1" ];

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [
    libjpeg libpng fontconfig freetype
    pam dbus
    xorg.libX11 xorg.libXext xorg.libXrandr xorg.libXrender xorg.libXmu xorg.libXft
  ];

  meta = with stdenv.lib; {
    description = "A lightweight display manager";
    homepage = src.meta.homepage;
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ oxij ];
  };
}
