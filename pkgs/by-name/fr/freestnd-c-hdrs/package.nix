{
  lib,
  fetchFromGitea,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "freestnd-c-hdrs";
  version = "0-unstable-2025-04-08";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "osdev";
    repo = "freestnd-c-hdrs";
    rev = "4039f438fb1dc1064d8e98f70e1cf122f91b763b";
    sha256 = "sha256-JMb1DS9+IDqGXdivMdy326kh+5iBniGc2RHihCfhLeA=";
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
