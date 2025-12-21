{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2025-12-14";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "6d2e3783fde1d99773a57a1ff0c14bfaeec22f93";
    hash = "sha256-/1S09xhwvLg6fDgujWVpHb5jQUqydTVTtEjHk4leYUY=";
  };

  makefile = "Makefile";
  preBuild = "cd src/os/libretro";
  dontConfigure = true;

  meta = {
    description = "Port of Stella to libretro";
    homepage = "https://github.com/stella-emu/stella";
    license = lib.licenses.gpl2Only;
  };
}
