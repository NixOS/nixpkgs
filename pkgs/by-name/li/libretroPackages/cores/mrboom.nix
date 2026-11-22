{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "mrboom";
  version = "0-unstable-2026-06-25";

  src = fetchFromGitHub {
    owner = "Javanaise";
    repo = "mrboom-libretro";
    rev = "40ac32020b540c4bb418c7d798a990932a65da04";
    hash = "sha256-Iirhd/Z/7ouTejoG6K87iGIsfTgKbThWv2QjlItcf94=";
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
