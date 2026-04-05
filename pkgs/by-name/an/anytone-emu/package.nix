{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  librsvg,
  kdePackages,
  hunspell,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "anytone-emu";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "dmr-tools";
    repo = "anytone-emu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RTYLtVCKP2TW7Ery51POEZuCtyRhkgKhoDhJPe18y80=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    hunspell
    librsvg
    kdePackages.qtserialport
    kdePackages.qtbase
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tiny emulator for AnyTone radios";
    homepage = "https://github.com/dmr-tools/anytone-emu";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "anytone-emu";
  };
})
