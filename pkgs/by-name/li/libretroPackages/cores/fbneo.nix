{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-11-08";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "77016b4dff6c76beba08d24ea1c61ed2750bc0a7";
    hash = "sha256-QoKdQrT5/oF81wfEKy9WnwFy5rj2x8vVk5RHSHdiw+4=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
