{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mgba";
  version = "0-unstable-2026-04-03";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mgba";
    rev = "6dce57eef127dc4cc292644f38196e0e7c58590c";
    hash = "sha256-sLxQ7NG5ypSQACo1Q/9/FwQKCpZsIU0Y35dLa8uhOVs=";
  };

  meta = {
    description = "Port of mGBA to libretro";
    homepage = "https://github.com/libretro/mgba";
    license = lib.licenses.mpl20;
  };
}
