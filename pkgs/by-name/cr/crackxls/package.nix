{ lib, stdenv, fetchFromGitHub, fetchpatch, pkg-config, autoconf, automake, openssl, libgsf, gmp }:

stdenv.mkDerivation rec {

  pname = "crackxls";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "GavinSmith0123";
    repo = "crackxls2003";
    rev = "v${version}";
    sha256 = "0q5jl7hcds3f0rhly3iy4fhhbyh9cdrfaw7zdrazzf1wswwhyssz";
  };

  patches = [
    # Pull patch pending upstream inclusion for -fno-common support:
    #   https://github.com/GavinSmith0123/crackxls2003/pull/3
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/GavinSmith0123/crackxls2003/commit/613d6c1844f76c7b67671aaa265375fed56c2a56.patch";
      sha256 = "1pk67x67d9wji576mc57z5bzqlf9ygvn9m1z47w12mad7qmj9h1n";
    })
  ];

  nativeBuildInputs = [ pkg-config autoconf automake ];
  buildInputs = [ openssl libgsf gmp ];

  # Avoid "-O5 -march=native"
  makeFlags = [ "OPTIM_FLAGS=" ];

  installPhase =
  ''
    mkdir -p $out/bin
    cp crackxls2003 $out/bin/
  '';

  meta = with lib; {
    homepage = "https://github.com/GavinSmith0123/crackxls2003/";
    description = "Used to break the encryption on old Microsoft Excel and Microsoft Word files";
    mainProgram = "crackxls2003";
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
