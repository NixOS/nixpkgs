{
  lib,
  stdenv,
  fetchurl,
  gpgme,
}:

stdenv.mkDerivation rec {
  pname = "nasty";
  version = "0.6";

  src = fetchurl {
    url = "https://www.vanheusden.com/nasty/${pname}-${version}.tgz";
    sha256 = "1dznlxr728k1pgy1kwmlm7ivyl3j3rlvkmq34qpwbwbj8rnja1vn";
  };

  # does not apply cleanly with patchPhase/fetchpatch
  # https://sources.debian.net/src/nasty/0.6-3/debian/patches/02_add_largefile_support.patch
  CFLAGS = "-D_FILE_OFFSET_BITS=64";

  buildInputs = [ gpgme ];

  installPhase = ''
    mkdir -p $out/bin
    cp nasty $out/bin
  '';

  meta = with lib; {
    description = "Recover the passphrase of your PGP or GPG-key";
    mainProgram = "nasty";
    longDescription = ''
      Nasty is a program that helps you to recover the passphrase of your PGP or GPG-key
      in case you forget or lost it. It is mostly a proof-of-concept: with a different implementation
      this program could be at least 100x faster.
    '';
    homepage = "http://www.vanheusden.com/nasty/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ davidak ];
    platforms = platforms.unix;
  };
}
