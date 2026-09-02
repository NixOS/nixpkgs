{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-08-06";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "ef1f64b7023bc511858e96b8961f99c18a09f112";
    hash = "sha256-BW53MDOnHc2AwbphywZw4AK1+X/bA5RIDl3Ae3OSQpM=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
