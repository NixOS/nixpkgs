{
  boost,
  catch2,
  cmake,
  curl,
  fetchFromGitHub,
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

  src = fetchFromGitHub {
    owner = "cfillion";
    repo = "reapack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RhXAjTNAJegeCJaYkvwJedZrXRA92dQ0EeHJr9ngeCg=";
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
    catch2
    curl
    libxml2
    openssl
    sqlite
    zlib
  ];

  cmakeFlags = [ "-Wno-dev" ];

})
