{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, pkg-config
, expat
, libproxy
, neon
, zlib
}:

stdenv.mkDerivation rec {
  version = "0.14";
  pname = "litmus";

  src = fetchFromGitHub {
    owner = "notroj";
    repo = "litmus";
    rev = version;
    # Required for neon m4 macros, bundled neon not used
    fetchSubmodules = true;
    hash = "sha256-jWz0cnytgn7px3vvB9/ilWBNALQiW5/QvgguM27I3yQ=";
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

  autoreconfFlags = [ "-I" "neon/macros" ];

  meta = with lib; {
    description = "WebDAV server protocol compliance test suite";
    homepage = "http://www.webdav.org/neon/litmus/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.lorenz ];
    mainProgram = "litmus";
  };
}

