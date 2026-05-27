{
  lib,
  boost,
  catch2_3,
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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "reaper-reapack-extension";
  version = "1.2.5";

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
    catch2_3
    curl
    libxml2
    openssl
    sqlite
    zlib
  ];

  cmakeFlags = [ "-Wno-dev" ];

  meta = {
    description = "Package manager for REAPER";
    homepage = "https://reapack.com/";
    license = with lib.licenses; [
      lgpl3Plus
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ pancaek ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };

})
