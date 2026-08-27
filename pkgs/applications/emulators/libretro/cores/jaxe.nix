{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "jaxe";
  version = "0-unstable-2026-04-02";

  src = fetchFromGitHub {
    owner = "kurtjd";
    repo = "jaxe";
    rev = "581befc5d7273abc20ea1b137744f414aa70592c";
    hash = "sha256-jJPg4qRxraz9wycAiWNgwXXZMF2qG8hQv7Bfexkwyqs=";
    fetchSubmodules = true;
  };

  meta = {
    description = "CHIP-8, S-CHIP, and XO-CHIP emulator core for libretro";
    homepage = "https://github.com/kurtjd/jaxe";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kaistarkk ];
  };
}
