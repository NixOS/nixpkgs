{
  stdenv,
  lib,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  gnutls,
  libmicrohttpd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libhttpserver";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "etr";
    repo = "libhttpserver";
    rev = finalAttrs.version;
    hash = "sha256-x/JSjTjDHfknr1VB1uApGgSGTdDkhGCZQCYj8PQ2UUE=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
  ];

  buildInputs = [
    gnutls
    libmicrohttpd
  ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs ./bootstrap
  '';

  preConfigure = ''
    ./bootstrap
  '';

  configureFlags = [ "--enable-same-directory-build" ];

  meta = {
    description = "C++ library for creating an embedded Rest HTTP server (and more)";
    homepage = "https://github.com/etr/libhttpserver";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ pongo1231 ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin; # configure: error: cannot find required auxiliary files: ltmain.sh
  };
})
