{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libxslt,
  freetype,
  libpng,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "swfmill";
  version = "0.3.6";

  src = fetchurl {
    url = "https://swfmill.org/releases/swfmill-${version}.tar.gz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libxslt
    freetype
    libpng
    libxml2
  ];

  # fatal error: 'libxml/xpath.h' file not found
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-I${libxml2.dev}/include/libxml2";

  meta = {
    description = "Xml2swf and swf2xml processor with import functionalities";
    homepage = "http://swfmill.org";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    mainProgram = "swfmill";
  };
}
