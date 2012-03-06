{ stdenv, fetchurl, libdvdread }:

stdenv.mkDerivation {
  name = "lxdvdrip-1.76";

  src = fetchurl {
    url = http://download.berlios.de/lxdvdrip/lxdvdrip-1.76.tgz;
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
    description = "Command line tool to make a copy from a video DVD for private use";
    homepage = http://lxdvdrip.berlios.de/;
    license = "GPLv2";
  };
}
