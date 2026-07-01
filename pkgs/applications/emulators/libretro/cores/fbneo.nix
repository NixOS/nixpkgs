{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-06-30";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "99f32487f53188404a2cdb69ec86b251b13cebc9";
    hash = "sha256-VztUqj//bt8OvDjAe3L61M7Y7fsVW2xELQ5jIb8TTLw=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
