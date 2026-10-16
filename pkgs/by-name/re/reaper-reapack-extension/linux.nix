{
  lib,
  boost,
  catch2_3,
  cmake,
  curl,
  fetchFromCodeberg,
  git,
  libxml2,
  openssl,
  php,
  ruby,
  sqlite,
  stdenv,
  zlib,

  pname,
  version,
  meta,
}:

stdenv.mkDerivation (finalAttrs: {
  inherit
    pname
    version
    meta
    ;

  src = fetchFromCodeberg {
    owner = "cfillion";
    repo = "reapack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M1EUBksCCcGD6zRT0Kr32t+inyKMieGR/y+KGxt/qrc=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    git
    php
    ruby
  ];

  buildInputs = [
    boost
    catch2_3
    curl
    libxml2
    openssl
    sqlite
    zlib
  ];

  cmakeFlags = [
    "-Wno-author"
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" "17")
  ];

})
