{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}:
let
  inherit (stdenvNoCC.hostPlatform) system;
  version = "2.0.1-19784";
  version' = lib.replaceString "-" "_" version;
  sourceData = {
    aarch64-darwin = {
      arch = "arm64";
      hash = "sha256-J4fmZJ0uQ9eYc9pzTh0cil54BYp2zsBga5zU2Drld4g=";
    };
    x86_64-darwin = {
      arch = "amd64";
      hash = "sha256-KUF5LBTAF8syr9OQhmNg+SAEvjjrwkI2qFhhkILR5Es=";
    };
  };
  sources = lib.mapAttrs (
    system:
    { arch, hash }:
    fetchurl {
      url = "https://cdn-updates.orbstack.dev/${arch}/OrbStack_v${version'}_${arch}.dmg";
      inherit hash;
    }
  ) sourceData;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "orbstack";
  inherit version;

  src = finalAttrs.passthru.sources.${system} or (throw "unsupported system ${system}");

  # -snld prevents "ERROR: Dangerous symbolic link path was ignored"
  # -xr'!*:com.apple.*' prevents macOS extended attributes (e.g. macl or
  # quarantine) being turned into real files when extracting an APFS .dmg
  # (e.g. Info.plist:com.apple.macl or Info.plist:com.apple.quarantine).
  # These bogus files corrupt the .app bundle and prevent it from launching.
  unpackCmd = "7zz x -snld -xr'!*:com.apple.*' $curSrc";

  nativeBuildInputs = [ _7zz ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R OrbStack.app "$out/Applications"

    mkdir -p "$out/bin"
    for bindir in bin xbin; do
      for binary in "$out/Applications/OrbStack.app/Contents/MacOS/$bindir"/*; do
        if [[ -f "$binary" ]]; then
          ln -s "$binary" "$out/bin/$(basename "$binary")"
        fi
      done
    done

    runHook postInstall
  '';

  passthru = {
    inherit sources;
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
