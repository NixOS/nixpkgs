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

stdenv.mkDerivation (finalAttrs: {
  pname = "lime";
  version = "5.3.72";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = "lime";
    rev = finalAttrs.version;
    hash = "sha256-iKp0q+nYrqrd5JUuQdE0u+WCNs7JmC7GGUd8TzP9Qs4=";
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
})
