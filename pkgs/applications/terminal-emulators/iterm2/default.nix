{ fetchzip, lib, stdenvNoCC }:

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
  version = "3.4.20";

  src = fetchzip {
    url = "https://iterm2.com/downloads/stable/iTerm2-${lib.replaceStrings ["."] ["_"] version}.zip";
    hash = "sha256-RXBv3RXd2Kq8k7rbOE3HPEf6vI64VZCo1IX03gDy7l0=";
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
    open -na "$APP_DIR" --args "$@"
    EOF
    chmod +x "$out/bin/iterm2"
    runHook postInstall
  '';

  meta = with lib; {
    description = "A replacement for Terminal and the successor to iTerm";
    homepage = "https://www.iterm2.com/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ steinybot tricktron ];
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}
