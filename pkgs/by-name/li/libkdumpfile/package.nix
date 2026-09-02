{
  lib,
  stdenv,
  fetchgit,
  autoconf,
  automake,
  libtool,
  autoreconfHook,
  pkg-config,
  zlib,
  libbfd,
  lzo,
  snappy,
  zstd,
  doxygen,
}:

stdenv.mkDerivation rec {
  pname = "libkdumpfile";
  version = "0.5.5";

  src = fetchgit {
    url = "https://codeberg.org/ptesarik/libkdumpfile.git";
    tag = "v${version}";
    hash = "sha256-Ilgh8WWfdwIN7fquS+az0U+eykOHgsGVX6G4hjx2L8I=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    zlib
    lzo
    snappy
    zstd
    libbfd
  ];

  configureFlags = [
    "--without-python"
  ];

  patches = [ ./kdumpid.patch ];

  meta = {
    description = "A library for accessing kernel crash dumps";
    homepage = "https://codeberg.org/ptesarik/libkdumpfile";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ panky ];
  };
}
