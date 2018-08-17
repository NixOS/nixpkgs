{ stdenv
, fetchurl
, fetchpatch
}:
stdenv.mkDerivation rec {
  name = "symmetrica-${version}";
  version = "2.0";

  src = fetchurl {
    url = "http://www.algorithm.uni-bayreuth.de/en/research/SYMMETRICA/SYM2_0_tar.gz";
    sha256 = "1qhfrbd5ybb0sinl9pad64rscr08qvlfzrzmi4p4hk61xn6phlmz";
    name = "symmetrica-2.0.tar.gz";
  };

  sourceRoot = ".";

  patches = [
      # don't show banner ("SYMMETRICA VERSION X - STARTING)
      # it doesn't contain very much helpful information and a banner is not ideal for a library
      (fetchpatch {
        url = "https://git.sagemath.org/sage.git/plain/build/pkgs/symmetrica/patches/de.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
        sha256 = "0df0vqixcfpzny6dkhyj87h8aznz3xn3zfwwlj8pd10bpb90k6gb";
      })

      # use int32_t and uint32_t for type INT
      # see https://trac.sagemath.org/ticket/13413
      (fetchpatch {
        name = "fix_64bit_integer_overflow.patch";
        url = "https://git.sagemath.org/sage.git/plain/build/pkgs/symmetrica/patches/int32.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
        sha256 = "0p33c85ck4kd453z687ni4bdcqr1pqx2756j7aq11bf63vjz4cyz";
      })

      (fetchpatch {
        url = "https://git.sagemath.org/sage.git/plain/build/pkgs/symmetrica/patches/return_values.patch?id=1615f58890e8f9881c4228c78a6b39b9aab1303a";
        sha256 = "0dmczkicwl50sivc07w3wm3jpfk78wm576dr25999jdj2ipsb7nk";
      })
  ];

  postPatch = ''
    substituteInPlace makefile --replace gcc cc
  '';

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p "$out"/{lib,share/doc/symmetrica,include/symmetrica}
    ar crs libsymmetrica.a *.o
    ranlib libsymmetrica.a
    cp libsymmetrica.a "$out/lib"
    cp *.h "$out/include/symmetrica"
    cp README *.doc "$out/share/doc/symmetrica"
  '';

  meta = {
    inherit version;
    description = ''A collection of routines for representation theory and combinatorics'';
    license = stdenv.lib.licenses.publicDomain;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;
    homepage = http://www.symmetrica.de/;
  };
}
