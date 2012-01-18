{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "qemu-linux-image-0.2";

  src = fetchurl {
    url = http://wiki.qemu.org/download/linux-0.2.img.bz2;
    sha256 = "08xlwy1908chpc4fsqy2v13zi25dapk0ybrd43fj95v67kdj5hj1";
  };

  unpackPhase = "true";

  installPhase =
    ''
      mkdir -p $out/share/qemu-images
      bunzip2 < $src > $out/share/qemu-images/linux-0.2.img
    '';

  meta = {
    description = "QEMU sample Linux disk image";
  };
}
