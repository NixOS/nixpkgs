{ lib, stdenv, fetchurl, libdvdread }:

stdenv.mkDerivation rec {
  pname = "lxdvdrip";
  version = "1.77";

  src = fetchurl {
    url = "mirror://sourceforge/lxdvdrip/lxdvdrip-${version}.tgz";
    hash = "sha256-OzHrscftsCmJvSw7bb/Z2WDP322VCuQDY58dW2OqxB8=";
  };

  postPatch = ''
    sed -i -e s,/usr/local,$out, -e s,/etc,$out/etc,g Makefile
    sed -i -e s,/usr/local,$out, mbuffer/Makefile
    makeFlags="$makeFlags PREFIX=$out"
  '';

  preInstall = ''
    mkdir -p $out/man/man1 $out/bin $out/share $out/etc
  '';

  buildInputs = [ libdvdread ];

  meta = {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    description = "Command line tool to make a copy from a video DVD for private use";
    homepage = "https://sourceforge.net/projects/lxdvdrip";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
