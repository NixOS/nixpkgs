{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "opera";
  version = "0-unstable-2026-06-09";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "opera-libretro";
    rev = "5e36d4a9fbb2afbb8de2313b8e2bf83998ec2341";
    hash = "sha256-TmSk0PIXOLToElUnyRkDFfpq3bvBh7+P8r8brYICJSY=";
  };

  makefile = "Makefile";
  makeFlags = [ "CC_PREFIX=${stdenv.cc.targetPrefix}" ];

  meta = {
    description = "Opera is a port of 4DO/libfreedo to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.unfreeRedistributable;
  };
}
