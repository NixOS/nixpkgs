{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "vba-next";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vba-next";
    rev = "82119ba97ee57c738a2eb1dc3a45cd2122ad2232";
    hash = "sha256-On2O4WBVLmuj5FJZyaYUtgCEl1mEZffqAvGZpKz+Or8=";
  };

  meta = {
    description = "VBA-M libretro port with modifications for speed";
    homepage = "https://github.com/libretro/vba-next";
    license = lib.licenses.gpl2Only;
  };
}
