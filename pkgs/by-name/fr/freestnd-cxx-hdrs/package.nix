{
  lib,
  fetchFromGitea,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "freestnd-cxx-hdrs";
  version = "0-unstable-2025-08-29";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "osdev";
    repo = "freestnd-cxx-hdrs";
    rev = "a6b351e0ab3e74e5789b01fa1447e4cd62373da7";
    sha256 = "sha256-sDXHMP/xTuL+DtaJgyxl322IWIXXcqRUbtJRMvYUmZY=";
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
