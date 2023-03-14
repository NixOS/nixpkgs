{ lib, stdenv, fetchurl, fetchpatch, zlib }:

stdenv.mkDerivation rec {
  pname = "bwa";
  version = "0.7.17";

  src = fetchurl {
    url = "mirror://sourceforge/bio-bwa/${pname}-${version}.tar.bz2";
    sha256 = "1zfhv2zg9v1icdlq4p9ssc8k01mca5d1bd87w71py2swfi74s6yy";
  };

  patches = [
    # Pull upstream patch for -fno-common toolchain support like upstream
    # gcc-10: https://github.com/lh3/bwa/pull/267
    (fetchpatch {
      name  = "fno-common.patch";
      url = "https://github.com/lh3/bwa/commit/2a1ae7b6f34a96ea25be007ac9d91e57e9d32284.patch";
      sha256 = "1lihfxai6vcshv5vr3m7yhk833bdivkja3gld6ilwrc4z28f6wqy";
    })
  ];

  buildInputs = [ zlib ];

  # Avoid hardcoding gcc to allow environments with a different
  # C compiler to build
  preConfigure = ''
    sed -i '/^CC/d' Makefile
  '';

  makeFlags = lib.optional stdenv.hostPlatform.isStatic "AR=${stdenv.cc.targetPrefix}ar";

  # it's unclear which headers are intended to be part of the public interface
  # so we may find ourselves having to add more here over time
  installPhase = ''
    install -vD -t $out/bin bwa
    install -vD -t $out/lib libbwa.a
    install -vD -t $out/include bntseq.h
    install -vD -t $out/include bwa.h
    install -vD -t $out/include bwamem.h
    install -vD -t $out/include bwt.h
  '';

  meta = with lib; {
    description = "A software package for mapping low-divergent sequences against a large reference genome, such as the human genome";
    license     = licenses.gpl3;
    homepage    = "https://bio-bwa.sourceforge.net/";
    maintainers = with maintainers; [ luispedro ];
    platforms = platforms.x86_64;
  };
}
