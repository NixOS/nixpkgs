{
  lib,
  fetchFromGitea,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "freestnd-cxx-hdrs";
  version = "0-unstable-2025-04-08";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "osdev";
    repo = "freestnd-cxx-hdrs";
    rev = "85096df5361a4d7ef2ce46947e555ec248c2858e";
    sha256 = "sha256-sQaIRgJgTLEci7kEJSsiGen/0jWSsyICqB5Ynk6XNu4=";
  };

  makeFlags = [
    "DESTDIR=/"
    "PREFIX=$(out)"
  ];

  meta = {
    description = "Headers from GCC's libstdc++ that can be used in a freestanding environment";
    homepage = "https://codeberg.org/osdev/freestnd-cxx-hdrs";
    platforms = lib.platforms.all;
    license = with lib.licenses; [
      gpl3Plus # with GCC Runtime Library Exception
    ];
    maintainers = with lib.maintainers; [ lzcunt ];
  };
}
