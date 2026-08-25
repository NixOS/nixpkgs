{
  clangStdenv,
  fetchFromGitHub,
  gnustep-back,
  lib,
  libx11,
  swift-corelibs-libdispatch,
  wrapGNUstepAppsHook,
}:

clangStdenv.mkDerivation {
  strictDeps = true;
  __structuredAttrs = true;
  pname = "gershwin-eau-theme";
  name = "gershwin-eau-theme";
  version = "0-unstable-2026-07-18";

  src = fetchFromGitHub {
    owner = "gershwin-desktop";
    repo = "gershwin-eau-theme";
    rev = "1551c7e6fe86858ebe09cee3ee0fa8d92b1cc9da";
    hash = "sha256-AkPkjVvK2ARPGMK4k7EgaHksO5+68Tsc8uUKI+PfZtQ=";
  };

  nativeBuildInputs = [
    wrapGNUstepAppsHook
  ];

  buildInputs = [
    gnustep-back
    libx11
    swift-corelibs-libdispatch
  ];

  meta = {
    homepage = "https://github.com/gershwin-desktop/gershwin-eau-theme";
    description = "The default theme for the Gershwin Desktop";
    maintainers = with lib.maintainers; [
      OulipianSummer
    ];
  };
  platforms = lib.platforms.linux;
}
