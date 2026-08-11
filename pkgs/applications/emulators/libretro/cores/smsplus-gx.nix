{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "smsplus";
  version = "0-unstable-2026-06-25";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "smsplus-gx";
    rev = "8a63f82d3c3bbf7215a31f86a4aaa13fb68a579f";
    hash = "sha256-yNaNkvRzpli4NMqFvlQ/6US7zw8xXiYWw6R0ev6ubLA=";
  };

  meta = {
    description = "SMS Plus GX libretro port";
    homepage = "https://github.com/libretro/smsplus-gx";
    license = lib.licenses.gpl2Plus;
  };
}
