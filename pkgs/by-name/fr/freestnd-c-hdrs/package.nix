{
  lib,
  fetchFromGitea,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "freestnd-c-hdrs";
  version = "0-unstable-2025-08-29";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "osdev";
    repo = "freestnd-c-hdrs";
    rev = "d33711241b46ecb8f2ad33927fcefdcb3ac0162e";
    sha256 = "sha256-gi+ZNmZvzYicRc/NZONFC2P984EXcyp7nUtT6vXaJ68=";
  };

  makeFlags = [
    "DESTDIR=/"
    "PREFIX=$(out)"
  ];

  meta = {
    description = "Headers from GCC that can be used in a freestanding environment";
    homepage = "https://codeberg.org/osdev/freestnd-c-hdrs";
    platforms = lib.platforms.all;
    license = with lib.licenses; [
      gpl3Plus # with GCC Runtime Library Exception
    ];
    maintainers = with lib.maintainers; [ lzcunt ];
  };
}
