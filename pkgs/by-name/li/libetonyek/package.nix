{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  boost,
  cppunit,
  glm,
  gperf,
  liblangtag,
  librevenge,
  libxml2,
  mdds,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libetonyek";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "LibreOffice";
    repo = "libetonyek";
    rev = "libetonyek-${finalAttrs.version}";
    hash = "sha256-dvYbV+7IakgOkGsZ+zaW+qgn/QoD6Jwq/juaE+7iYug=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gperf
  ];

  buildInputs = [
    boost
    cppunit
    glm
    liblangtag
    librevenge
    libxml2
    mdds
    zlib
  ];

  configureFlags = [ "--with-mdds=2.1" ];

  strictDeps = true;

  enableParallelBuilding = true;

  meta = {
    description = "Library and a set of tools for reading and converting Apple iWork documents (Keynote, Pages and Numbers)";
    homepage = "https://github.com/LibreOffice/libetonyek";
    changelog = "https://github.com/LibreOffice/libetonyek/blob/${finalAttrs.src.rev}/NEWS";
    license = lib.licenses.mpl20;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
