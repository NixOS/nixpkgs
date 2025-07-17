{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mgba";
  version = "0-unstable-2025-05-18";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mgba";
    rev = "c9bbf28b091c4c104485092279c7a6b114b2e8ff";
    hash = "sha256-yCRM2qkacGbFVr6x0ZHBCZ8xAMruFENBdcnNKzK0sY4=";
  };

  meta = {
    description = "Port of mGBA to libretro";
    homepage = "https://github.com/libretro/mgba";
    license = lib.licenses.mpl20;
  };
}
