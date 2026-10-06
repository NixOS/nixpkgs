{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "smsplus";
  version = "0-unstable-2026-09-04";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "smsplus-gx";
    rev = "3844b46caa926b6494987b97da63092818c4ddef";
    hash = "sha256-1DAxk0C6ee0WyYih4jOkVeegazegQBTumqH0WOkos+U=";
  };

  meta = {
    description = "SMS Plus GX libretro port";
    homepage = "https://github.com/libretro/smsplus-gx";
    license = lib.licenses.gpl2Plus;
  };
}
