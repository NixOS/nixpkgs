{
  stdenv,
  lib,
  fetchurl,
  autoreconfHook,
  pkg-config,
  libopenmpt,
}:

stdenv.mkDerivation rec {
  pname = "libopenmpt-modplug";
  version = "0.8.9.0-openmpt1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://lib.openmpt.org/files/libopenmpt-modplug/libopenmpt-modplug-${version}.tar.gz";
    sha256 = "sha256-7M4aDuz9sLWCTKuJwnDc5ZWWKVosF8KwQyFez018T/c=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libopenmpt
  ];

  configureFlags = [
    "--enable-libmodplug"
  ];

  meta = with lib; {
    description = "Libmodplug emulation layer based on libopenmpt";
    homepage = "https://lib.openmpt.org/libopenmpt/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.unix;
  };
}
