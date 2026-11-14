{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  jansson,
}:

let
  libsailing = fetchFromGitHub {
    owner = "sails-simulator";
    repo = "libsailing";
    rev = "9b2863ff0c539cd23d91b0254032a7af9c840574";
    hash = "sha256-0uAXbrkrNF8OaXoyUqGKQL9tJWHWch0y7jrp+vjsLBs=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  version = "0.3.0";
  pname = "sailsd";
  src = fetchFromGitHub {
    owner = "sails-simulator";
    repo = "sailsd";
    rev = finalAttrs.version;
    hash = "sha256-BWhZWskBhq0JcTJktqiXawYTmV6f896WjWsgc52jlug=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    jansson
    libsailing
  ];

  env.INSTALL_PATH = "$(out)";

  postUnpack = ''
    rmdir $sourceRoot/libsailing
    cp -r ${libsailing} $sourceRoot/libsailing
    chmod 755 -R $sourceRoot/libsailing
  '';

  patchPhase = ''
    substituteInPlace Makefile \
      --replace gcc cc
  '';

  meta = {
    description = "Simulator daemon for autonomous sailing boats";
    homepage = "https://github.com/sails-simulator/sailsd";
    license = lib.licenses.gpl3;
    longDescription = ''
      Sails is a simulator designed to test the AI of autonomous sailing
      robots. It emulates the basic physics of sailing a small single sail
      boat'';
    maintainers = with lib.maintainers; [ kragniz ];
    platforms = lib.platforms.all;
    mainProgram = "sailsd";
  };
})
