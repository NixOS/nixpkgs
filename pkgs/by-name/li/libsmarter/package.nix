{
  fetchFromGitHub,
  stdenvNoCC,
  lib,
  meson,
  ninja,
}:

stdenvNoCC.mkDerivation {
  pname = "libsmarter";
  version = "0-unstable-2026-04-08";

  src = fetchFromGitHub {
    owner = "managarm";
    repo = "libsmarter";
    rev = "f7d061bc37d485418344452c7ceb28d5df3ba85d";
    sha256 = "sha256-K2K2Vya8uOtcVBhogbaS7xN8KKMiWvStHQD7MWF3EWk=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "More powerful reference-counting smart pointers for C++";
    homepage = "https://github.com/managarm/libsmarter";
    platforms = lib.platforms.all;
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ lzcunt ];
  };
}
