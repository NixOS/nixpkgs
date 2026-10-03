{
  lib,
  fetchFromGitHub,
  gitMinimal,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "sameduck";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "sameduck";
    rev = "f0286ee9d6c44950d9a442463ffdb1ff014a5d5b";
    hash = "sha256-R7nay5yuxTlxbVbI0UYnzpQvPXwMJt+8hCnC90/dkR0=";
  };

  sourceRoot = "source";
  makefile = "libretro/Makefile";
  makeFlags = [ "CORE_DIR=." ];

  extraNativeBuildInputs = [ gitMinimal ];

  postPatch = ''
    substituteInPlace libretro/Makefile \
      --replace-fail 'include Makefile.common' 'include libretro/Makefile.common' \
      --replace-fail 'MKDIR := $(shell which mkdir)' 'MKDIR := mkdir'
  '';

  meta = {
    description = "Mega Duck emulator core for libretro";
    homepage = "https://github.com/libretro/sameduck";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kaistarkk ];
  };
}
