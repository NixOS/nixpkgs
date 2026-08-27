{
  clangStdenv,
  fetchFromGitHub,
  gnustep-back,
  lib,
  libx11,
  wrapGNUstepAppsHook,
}:

clangStdenv.mkDerivation {
  strictDeps = true;
  __structuredAttrs = true;
  pname = "gershwin-terminal";
  version = "0-unstable-2026-07-12";

  src = fetchFromGitHub {
    owner = "gershwin-desktop";
    repo = "gershwin-terminal";
    rev = "e52b9bc8401f9e28f322001dce8e2d45632bdedd";
    hash = "sha256-NqYSfCH93M0Gx9hdqWOkG3u9TxgG6TToe9OKZkAd/cI=";
  };

  patches = [
    ./patches/TerminalViewGNU.patch
  ];

  nativeBuildInputs = [
    wrapGNUstepAppsHook
  ];

  buildInputs = [
    libx11
    gnustep-back
  ];

  meta = {
    homepage = "https://github.com/gershwin-desktop/gershwin-terminal";
    description = "The terminal emulator for Gershwin Desktop";
    license = lib.licenses.gpl2Only;
    mainProgram = "Terminal";
    maintainers = with lib.maintainers; [
      OulipianSummer
    ];
  };
  platforms = lib.platforms.linux;
}
