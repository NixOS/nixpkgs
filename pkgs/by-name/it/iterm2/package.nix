{
  fetchzip,
  lib,
  stdenvNoCC,
}:

/*
  This cannot be built from source as it requires entitlements and
  for that it needs to be code signed. Automatic updates will have
  to be disabled via preferences instead of at build time. To do
  that edit $HOME/Library/Preferences/com.googlecode.iterm2.plist
  and add:
  SUEnableAutomaticChecks = 0;
*/

stdenvNoCC.mkDerivation rec {
  pname = "iterm2";
  version = "3.6.6";

  src = fetchzip {
    url = "https://iterm2.com/downloads/stable/iTerm2-${
      lib.replaceStrings [ "." ] [ "_" ] version
    }.zip";
    hash = "sha256-n3VoRxMOBQK/8mbVbORSBz73tsuKAUMG7dFZIbaqdHU=";
  };

  dontFixup = true;

  installPhase = ''
    runHook preInstall
    APP_DIR="$out/Applications/iTerm2.app"
    mkdir -p "$APP_DIR"
    cp -r . "$APP_DIR"
    mkdir -p "$out/bin"
    cat << EOF > "$out/bin/iterm2"
    #!${stdenvNoCC.shell}
    open -na "$APP_DIR" --args "\$@"
    EOF
    chmod +x "$out/bin/iterm2"
    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Replacement for Terminal and the successor to iTerm";
    homepage = "https://www.iterm2.com/";
    hydraPlatforms = [ ]; # The build is little more than copying the binary
    license = licenses.gpl2;
    maintainers = with maintainers; [
      tricktron
      emaiax
    ];
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
}
