{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "jaxe";
  version = "0-unstable-2026-07-24";

  src = fetchFromGitHub {
    owner = "kurtjd";
    repo = "jaxe";
    rev = "c767afd785e01a15bcd575a2d93b737add82b675";
    hash = "sha256-qkoYVzAFiMACHt9Zx2qfNhUig6DEovyXZ2jE/GLo+ro=";
    fetchSubmodules = true;
  };

  meta = {
    description = "CHIP-8, S-CHIP, and XO-CHIP emulator core for libretro";
    homepage = "https://github.com/kurtjd/jaxe";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kaistarkk ];
  };
}
