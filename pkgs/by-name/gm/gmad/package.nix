{
  lib,
  stdenv,
  fetchFromGitHub,
  premake4,
  bootil,
}:

stdenv.mkDerivation rec {
  pname = "gmad";
  version = "0-unstable-2020-02-24";

  meta = {
    description = "Garry's Mod Addon Creator and Extractor";
    homepage = "https://github.com/Facepunch/gmad";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.abigailbuccaneer ];
    platforms = lib.platforms.all;
  };

  src = fetchFromGitHub {
    owner = "Facepunch";
    repo = "gmad";
    rev = "5236973a2fcbb3043bdd3d4529ce68b6d938ad93";
    hash = "sha256-2hxhX6AHQ6KarrPlB3FZ1qMVA9kFAA7irWhIu+0JVhE=";
  };

  buildInputs = [
    premake4
    bootil
  ];

  targetName =
    if stdenv.hostPlatform.isLinux then
      "gmad_linux"
    else if stdenv.hostPlatform.isDarwin then
      "gmad_osx"
    else
      "gmad";

  premakeFlags = [
    "--bootil_lib=${bootil}/lib"
    "--bootil_inc=${bootil}/include"
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${targetName} $out/bin/gmad
  '';
}
