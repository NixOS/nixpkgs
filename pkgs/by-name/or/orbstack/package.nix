{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
  installShellFiles,
}:
let
  inherit (stdenvNoCC.hostPlatform) system;
  version = "2.2.1-20628";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "orbstack";
  inherit version;

  src = fetchurl {
    url = "https://cdn-updates.orbstack.dev/arm64/OrbStack_v${
      lib.replaceString "-" "_" version
    }_arm64.dmg";
    hash = "sha256-W8FxnDyYfExgxlvp/dZbRzCZDhaX7Byxwz5rujG/krU=";
  };

  # -snld prevents "ERROR: Dangerous symbolic link path was ignored"
  # -xr'!*:com.apple.*' prevents macOS extended attributes (e.g. macl or
  # quarantine) being turned into real files when extracting an APFS .dmg
  # (e.g. Info.plist:com.apple.macl or Info.plist:com.apple.quarantine).
  # These bogus files corrupt the .app bundle and prevent it from launching.
  unpackCmd = "7zz x -snld -xr'!*:com.apple.*' $curSrc";

  nativeBuildInputs = [
    _7zz
    installShellFiles
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R OrbStack.app "$out/Applications"

    mkdir -p "$out/bin"
    for binary in "$out"/Applications/OrbStack.app/Contents/MacOS/{bin,xbin}/*; do
      ln -s "$binary" "$out/bin/$(basename "$binary")"
    done

    runHook postInstall
  '';

  postInstall = ''
    installShellCompletion --bash "$out"/Applications/OrbStack.app/Contents/Resources/completions/bash/{docker,kubectl,orbctl}.bash
    installShellCompletion --zsh "$out"/Applications/OrbStack.app/Contents/Resources/completions/zsh/{_docker,_kubectl,_orb,_orbctl}
    installShellCompletion --fish "$out"/Applications/OrbStack.app/Contents/Resources/completions/fish/{docker,kubectl,orbctl}.fish
  '';

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    changelog = "https://docs.orbstack.dev/release-notes#${
      builtins.replaceStrings [ "." ] [ "-" ] version
    }";
    description = "Fast, light, and easy way to run Docker containers and Linux machines";
    homepage = "https://orbstack.dev/";
    license = lib.licenses.unfree;
    mainProgram = "orb";
    maintainers = with lib.maintainers; [ deejayem ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
