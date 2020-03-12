{stdenv, fetchurl, zlib, gmp, ecm }:

stdenv.mkDerivation {
  name = "msieve-1.53";

  src = fetchurl {
    url = mirror://sourceforge/msieve/msieve/Msieve%20v1.53/msieve153_src.tar.gz;
    sha256 = "1d1vv7j4rh3nnxsmvafi73qy7lw7n3akjlm5pjl3m936yapvmz65";
  };

  buildInputs = [ zlib gmp ecm ];

  ECM = if ecm == null then "0" else "1";

  # Doesn't hurt Linux but lets clang-based platforms like Darwin work fine too
  makeFlags = [ "CC=cc" "all" ];

  installPhase = ''
    mkdir -p $out/bin/
    cp msieve $out/bin/
  '';

  meta = {
    description = "A C library implementing a suite of algorithms to factor large integers";
    license = stdenv.lib.licenses.publicDomain;
    homepage = http://msieve.sourceforge.net/;
    maintainers = [ stdenv.lib.maintainers.roconnor ];
    platforms = [ "x86_64-linux" ] ++ stdenv.lib.platforms.darwin;
  };
}
