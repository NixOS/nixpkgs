{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}:
let
  inherit (stdenvNoCC.hostPlatform) system;
  buildVersion = "1.11.3_19358";
  srcs = {
    aarch64-darwin = fetchurl {
      url = "https://cdn-updates.orbstack.dev/arm64/OrbStack_v${buildVersion}_arm64.dmg";
      hash = "sha256-AzH1rZFqEH8sovZZfJykvsEmCedEZWigQFHWHl6/PdE=";
    };
    x86_64-darwin = fetchurl {
      url = "https://cdn-updates.orbstack.dev/amd64/OrbStack_v${buildVersion}_amd64.dmg";
      hash = "sha256-oLOTKekDU880p9DtzcR/muwzPuFA3vu789aEYNFbcx8=";
    };
  };
in
stdenvNoCC.mkDerivation {
  pname = "orbstack";
  version = lib.head (lib.splitString "_" buildVersion);

  src = srcs.${system} or (throw "unsupported system ${system}");

  # fix "ERROR: Dangerous symbolic link path was ignored"
  unpackCmd = "7zz x -snld $curSrc";

  nativeBuildInputs = [ _7zz ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    # Fix "this app is damaged and can't be opened"
    #
    # When extracting an APFS .dmg with 7zz (7-Zip), it may incorrectly turn
    # macOS extended attributes (like quarantine or macl) into real files:
    #   Info.plist:com.apple.quarantine
    #   Info.plist:com.apple.macl
    #
    # These bogus files corrupt the .app bundle and prevent it from launching.
    # Delete them to restore proper behavior.
    find OrbStack.app -name '*:com.apple.*' -delete

    mkdir -p "$out/Applications"
    cp -R OrbStack.app "$out/Applications"

    for bindir in bin xbin; do
      for binary in "$out/Applications/OrbStack.app/Contents/MacOS/$bindir"/*; do
        if [[ -f "$binary" ]]; then
          ln -s "$binary" "$out/bin/$(basename "$binary")"
        fi
      done
    done

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://docs.orbstack.dev/release-notes";
    description = "Fast, light, and easy way to run Docker containers and Linux machines";
    homepage = "https://orbstack.dev/";
    license = lib.licenses.unfree;
    mainProgram = "orb";
    maintainers = with lib.maintainers; [ asterismono ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
