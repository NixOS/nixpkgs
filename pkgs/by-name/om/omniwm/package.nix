{
  fetchurl,
  libarchive,
  lib,
  stdenvNoCC,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "omniwm";
  version = "0.6.3";

  src = fetchurl {
    url = "https://github.com/BarutSRB/OmniWM/releases/download/v${finalAttrs.version}/OmniWM-v${finalAttrs.version}.zip";
    hash = "sha256-rDRDQYOUxvntH5mA1EoXa6LPeqV2zN3OpnaD+eHOLiU=";
  };

  sourceRoot = "OmniWM.app";

  __structuredAttrs = true;
  strictDeps = true;

  # Using bsdtar instead of unzip as unzip breaks .app codesigning.
  # Unpack using bsdtar before installation instead.
  unpackCmd = # bash
    ''bsdtar -xf "$curSrc"'';

  nativeBuildInputs = [ libarchive ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/OmniWM.app"
    cp -r . "$out/Applications/OmniWM.app"

    # Symlink executables to bin
    mkdir -p "$out/bin"
    ln -s "$out/Applications/OmniWM.app/Contents/MacOS/OmniWM" "$out/bin/OmniWM"
    ln -s "$out/Applications/OmniWM.app/Contents/MacOS/omniwmctl" "$out/bin/omniwmctl"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  # No version checks are possible as `omniwmctl version` expects a running OmniWM instance with IPC enabled.

  meta = {
    description = "MacOS Niri and Hyprland inspired tiling window manager";
    homepage = "https://github.com/BarutSRB/OmniWM";
    license = lib.licenses.gpl2Only;
    mainProgram = "OmniWM";
    platforms = [ "aarch64-darwin" ];
    maintainers = with lib.maintainers; [
      mmfallacy
      samiser
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
