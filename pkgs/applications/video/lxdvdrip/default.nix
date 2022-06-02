{ lib, stdenv, fetchurl, libdvdread }:

stdenv.mkDerivation rec {
  pname = "lxdvdrip";
  version = "1.76";

  src = fetchurl {
    url = "mirror://sourceforge/lxdvdrip/lxdvdrip-${version}.tgz";
    sha256 = "0vgslc7dapfrbgslnaicc8bggdccyrvcgjv1dwi19qswhh7jkzj6";
  };

  prePatch = ''
    sed -i -e s,/usr/local,$out, -e s,/etc,$out/etc,g Makefile
    sed -i -e s,/usr/local,$out, buffer/Makefile
    makeFlags="$makeFlags PREFIX=$out"
  '';

  preInstall = ''
    mkdir -p $out/man/man1 $out/bin $out/share $out/etc
  '';

  buildInputs = [ libdvdread ];

  meta = {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "Command line tool to make a copy from a video DVD for private use";
    homepage = "https://sourceforge.net/projects/lxdvdrip";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
