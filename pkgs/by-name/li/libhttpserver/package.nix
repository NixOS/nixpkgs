{ stdenv
, lib
, fetchFromGitHub
, autoconf
, automake
, libtool
, gnutls
, libmicrohttpd
}:

stdenv.mkDerivation rec {
  pname = "libhttpserver";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "etr";
    repo = pname;
    rev = version;
    hash = "sha256-Pc3Fvd8D4Ymp7dG9YgU58mDceOqNfhWE1JtnpVaNx/Y=";
  };

  nativeBuildInputs = [ autoconf automake libtool ];

  buildInputs = [ gnutls libmicrohttpd ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs ./bootstrap
  '';

  preConfigure = ''
    ./bootstrap
  '';

  configureFlags = [ "--enable-same-directory-build" ];

  meta = with lib; {
    description = "C++ library for creating an embedded Rest HTTP server (and more)";
    homepage = "https://github.com/etr/libhttpserver";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ pongo1231 ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin; # configure: error: cannot find required auxiliary files: ltmain.sh
  };
}
