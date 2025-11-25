{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}:
let
  inherit (stdenvNoCC.hostPlatform) system;
  version = "2.0.5-19905";
  sourceData = {
    aarch64-darwin = {
      arch = "arm64";
      hash = "sha256-YBiJVRzf3H/u4Ui3/bBID6C6XA2wvo8cBH/IQIhqdXE=";
    };
    x86_64-darwin = {
      arch = "amd64";
      hash = "sha256-qFj6Lc0m9/dc1/mcJO0aafRZs5vyCQyCb5l+zJwdF+s=";
    };
  };
  sources = lib.mapAttrs (
    system:
    { arch, hash }:
    fetchurl {
      url = "https://cdn-updates.orbstack.dev/${arch}/OrbStack_v${
        lib.replaceString "-" "_" version
      }_${arch}.dmg";
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
    for binary in "$out"/Applications/OrbStack.app/Contents/MacOS/{bin,xbin}/*; do
      ln -s "$binary" "$out/bin/$(basename "$binary")"
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
