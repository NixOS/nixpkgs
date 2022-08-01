{ lib, stdenv, fetchurl, zlib, gmp, ecm }:

stdenv.mkDerivation rec {
  pname = "msieve";
  version = "1.53";
  outputs = [ "out" "lib" "dev" ];

  src = fetchurl {
    url = "mirror://sourceforge/msieve/msieve/Msieve%20v${version}/msieve${lib.replaceStrings ["."] [""] version}_src.tar.gz";
    sha256 = "1d1vv7j4rh3nnxsmvafi73qy7lw7n3akjlm5pjl3m936yapvmz65";
  };

  patches = [
    # Disable i686 SIMD optimisations that are unsupported by nix
    ./disable-i686-assembly.patch
  ];

  buildInputs = [ zlib gmp ecm ];

  ECM = if ecm == null then "0" else "1";

  # Doesn't hurt Linux but lets clang-based platforms like Darwin work fine too
  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" "all" ];

  installPhase = ''
    runHook preInstall

    install -D msieve $out/bin/msieve
    install -D libmsieve.a $lib/lib/libmsieve.a
    install -D include/msieve.h $dev/include/msieve.h

    runHook postInstall
  '';

  meta = with lib; {
    description = "A C library implementing a suite of algorithms to factor large integers";
    license = licenses.publicDomain;
    homepage = "http://msieve.sourceforge.net/";
    maintainers = with maintainers; [ roconnor emilytrau ];
    platforms = platforms.unix;
  };
}
