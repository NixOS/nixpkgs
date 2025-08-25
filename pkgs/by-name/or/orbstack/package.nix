{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}:
let
  inherit (stdenvNoCC.hostPlatform) system;
  version = "1.11.3-19358";
  version' = lib.replaceString "-" "_" version;
  sources = {
    aarch64-darwin = fetchurl {
      url = "https://cdn-updates.orbstack.dev/arm64/OrbStack_v${version'}_arm64.dmg";
      hash = "sha256-/zujkmctMdJUm3d7Rjjeic8QrvWSlEAUhjFgouBXeNw=";
    };
    x86_64-darwin = fetchurl {
      url = "https://cdn-updates.orbstack.dev/amd64/OrbStack_v${version'}_amd64.dmg";
      hash = "sha256-oLOTKekDU880p9DtzcR/muwzPuFA3vu789aEYNFbcx8=";
    };
  };
in
stdenvNoCC.mkDerivation {
  pname = "orbstack";
  inherit version;

  src = sources.${system} or (throw "unsupported system ${system}");

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
    maintainers = with lib.maintainers; [ asterismono ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
