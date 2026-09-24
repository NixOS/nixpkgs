{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "mrboom";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "Javanaise";
    repo = "mrboom-libretro";
    rev = "96f89550a3518dffe2e7561c971119a39d90de97";
    hash = "sha256-EcRXh39mldlI6fcrV1gaL/r1SGvrFe7jo35iQ47nTmo=";
    fetchSubmodules = true;
  };

  makefile = "Makefile";
  makeFlags = [ "GIT_VERSION=${builtins.substring 0 7 src.rev}" ];

  meta = {
    description = "Port of Mr.Boom to libretro";
    homepage = "https://github.com/Javanaise/mrboom-libretro";
    license = lib.licenses.mit;
  };
}
