{
  bctoolbox,
  belr,
  cmake,
  fetchFromGitLab,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "belcard";
  version = "5.3.72";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = "belcard";
    rev = finalAttrs.version;
    sha256 = "sha256-bRJNlTPB3h4YRs3N2CyrjLCkuGKPDN4PQhU24Y4LFKQ=";
  };

  buildInputs = [
    bctoolbox
    belr
  ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DENABLE_STATIC=NO" # Do not build static libraries
    "-DENABLE_UNIT_TESTS=NO" # Do not build test executables
  ];

  meta = with lib; {
    description = "C++ library to manipulate VCard standard format. Part of the Linphone project";
    homepage = "https://gitlab.linphone.org/BC/public/belcard";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
})
