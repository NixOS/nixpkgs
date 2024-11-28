{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "mrboom";
  version = "0-unstable-2024-07-01";

  src = fetchFromGitHub {
    owner = "Javanaise";
    repo = "mrboom-libretro";
    rev = "22765ce7176d236d846f504318a51c448d2b469b";
    hash = "sha256-hzdc4PM/EARNEtpeATo4VohXtkeBra6rCz3tdIgBfVw=";
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
