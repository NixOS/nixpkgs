{
  bctoolbox,
  belle-sip,
  cmake,
  fetchFromGitLab,
  lib,
  bc-soci,
  sqlite,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "lime";
  version = "5.2.98";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = "lime";
    rev = version;
    hash = "sha256-LdwXBJpwSA/PoCXL+c1pcX1V2Fq/eR6nNmwBKDM1Vr8=";
  };

  buildInputs = [
    # Made by BC
    bctoolbox
    belle-sip

    # Vendored by BC
    bc-soci

    sqlite
  ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DENABLE_STATIC=NO" # Do not build static libraries
    "-DENABLE_UNIT_TESTS=NO" # Do not build test executables
  ];

  meta = with lib; {
    description = "End-to-end encryption library for instant messaging. Part of the Linphone project";
    homepage = "https://www.linphone.org/technical-corner/lime";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
