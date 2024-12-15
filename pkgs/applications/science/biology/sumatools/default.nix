{
  lib,
  gccStdenv,
  fetchFromGitLab,
  zlib,
}:

let
  stdenv = gccStdenv;
  meta = with lib; {
    description = "Fast and exact comparison and clustering of sequences";
    homepage = "https://metabarcoding.org/sumatra";
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.unix;
  };

in
rec {

  # Suma library
  sumalibs = stdenv.mkDerivation rec {
    version = "1.0.34";
    pname = "sumalibs";
    src = fetchFromGitLab {
      domain = "git.metabarcoding.org";
      owner = "obitools";
      repo = pname;
      rev = "sumalib_v${version}";
      sha256 = "0hwkrxzfz7m5wdjvmrhkjg8kis378iaqr5n4nhdhkwwhn8x1jn5a";
    };
    makeFlags = [ "PREFIX=$(out)" ];
    inherit meta;
  };

  # Sumatra
  sumatra = stdenv.mkDerivation rec {
    version = "1.0.34";
    pname = "sumatra";
    src = fetchFromGitLab {
      domain = "git.metabarcoding.org";
      owner = "obitools";
      repo = pname;
      rev = "${pname}_v${version}";
      sha256 = "1bbpbdkshdc3xffqnr1qfy8qk64ldsmdc3s8mrcrlx132rgbi5f6";
    };
    buildInputs = [
      sumalibs
      zlib
    ];
    makeFlags = [
      "LIBSUMA=${sumalibs}/lib/libsuma.a"
      "LIBSUMAPATH=-L${sumalibs}"
      "PREFIX=$(out)"
    ];
    inherit meta;
  };

  # Sumaclust
  sumaclust = stdenv.mkDerivation rec {
    version = "1.0.34";
    pname = "sumaclust";
    src = fetchFromGitLab {
      domain = "git.metabarcoding.org";
      owner = "obitools";
      repo = pname;
      rev = "${pname}_v${version}";
      sha256 = "0x8yi3k3jxhmv2krp4rcjlj2f9zg0qrk7gx4kpclf9c3yxgsgrds";
    };
    buildInputs = [ sumalibs ];
    makeFlags = [
      "LIBSUMA=${sumalibs}/lib/libsuma.a"
      "LIBSUMAPATH=-L${sumalibs}"
      "PREFIX=$(out)"
    ];
    inherit meta;
  };
}
