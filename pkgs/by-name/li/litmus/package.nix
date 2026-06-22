{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  expat,
  libproxy,
  neon,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.17";
  pname = "litmus";

  src = fetchFromGitHub {
    owner = "notroj";
    repo = "litmus";
    tag = finalAttrs.version;
    # Required for neon m4 macros, bundled neon not used
    fetchSubmodules = true;
    hash = "sha256-JsFyZeaUTDCFZtlG8kyycTE14i4U4R6lTTVWLPjKGPU=";
  };

  postPatch = ''
    # neon version requirements are broken, remove them:
    # configure: incompatible neon library version 0.32.5: wanted 0.27 28 29 30 31 32
    # configure: using bundled neon (0.32.5)
    sed -i /NE_REQUIRE_VERSIONS/d configure.ac
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    expat
    libproxy
    neon
    zlib
  ];

  autoreconfFlags = [
    "-I"
    "neon/macros"
  ];

  meta = {
    description = "WebDAV server protocol compliance test suite";
    homepage = "http://www.webdav.org/neon/litmus/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.lorenz ];
    mainProgram = "litmus";
  };
})
