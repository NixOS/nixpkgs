{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "mrboom";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "Javanaise";
    repo = "mrboom-libretro";
    rev = "d011acfbdb2d93ed38bd684ccfa0db79bda1c932";
    hash = "sha256-DjTSrp38MwdEtUZPTgZYEZHWgv48IN1oHkKsVqmOwII=";
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
