{
  bcunit,
  cmake,
  bc-decaf,
  fetchFromGitLab,
  mbedtls_2,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bctoolbox";
  version = "5.3.72";

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    # Made by BC
    bcunit

    # Vendored by BC
    bc-decaf

    mbedtls_2
  ];

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = "bctoolbox";
    rev = finalAttrs.version;
    hash = "sha256-6ktcYTUGbiFIKPT7ShiGNZXStyRW+cLojCt7m5HTKO4=";
  };

  # Do not build static libraries
  cmakeFlags = [
    "-DENABLE_STATIC=NO"
    "-DENABLE_STRICT=NO"
  ];

  strictDeps = true;

  meta = with lib; {
    description = "Utilities library for Linphone";
    mainProgram = "bctoolbox_tester";
    homepage = "https://gitlab.linphone.org/BC/public/bctoolbox";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      raskin
      jluttine
    ];
    platforms = platforms.linux;
  };
})
