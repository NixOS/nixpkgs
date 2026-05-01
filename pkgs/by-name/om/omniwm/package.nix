{
  fetchurl,
  libarchive,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: rec {
  pname = "OmniWM";
  version = "0.4.7.4";

  src = fetchurl {
    url = "https://github.com/BarutSRB/OmniWM/releases/download/v${version}/OmniWM-v${version}.zip";
    sha256 = "sha256-6POMtHn5R1CQcz29QORrJaEuBxMPe7aYTtn0VWpQXIo=";
  };

  # Using bsdtar instead of unzip as unzip breaks .app codesigning.
  # Unpack using bsdtar before installation instead.
  unpackCmd = # bash
    "bsdtar -xf $curSrc";

  nativeBuildInputs = [ libarchive ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/
    cp -r "$PWD" $out/Applications/

    # Symlink executables to bin
    mkdir -p $out/bin
    ln -s $out/Applications/OmniWM.app/Contents/MacOS/OmniWM $out/bin/OmniWM
    ln -s $out/Applications/OmniWM.app/Contents/MacOS/omniwmctl $out/bin/omniwmctl

    runHook postInstall
  '';

  # No version checks are possible as `omniwmctl version` expects a running OmniWM instance with IPC enabled.

  meta = {
    description = "MacOS Niri and Hyprland inspired tiling window manager.";
    longDescription = "MacOS Niri and Hyprland inspired tiling window manager that's developer signed and notorized (safe for managed enterprise environments). Aiming for parity and extra innovation.";
    homepage = "https://github.com/BarutSRB/OmniWM";
    license = lib.licenses.gpl2Only;
    mainProgram = "OmniWM";
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ mmfallacy ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
