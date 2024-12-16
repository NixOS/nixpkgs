{
  stdenv,
  lib,
  fetchurl,
  _7zz,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "signal-desktop";
  version = "7.35.0";

  src = fetchurl {
    url = "https://updates.signal.org/desktop/signal-desktop-mac-universal-${finalAttrs.version}.dmg";
    hash = "sha256-+ZzZp3/koitwtHyUmcgltcYo91KfDfQzOjnOzTJJu6c=";
  };
  sourceRoot = ".";

  nativeBuildInputs = [ _7zz ];

  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r Signal.app $out/Applications

    runHook postInstall
  '';

  passthru = {
    updateScript.command = [ ./update.sh ];
  };

  meta = {
    description = "Private, simple, and secure messenger";
    longDescription = ''
      Signal Desktop is an Electron application that links with your
      "Signal Android" or "Signal iOS" app.
    '';
    homepage = "https://signal.org/";
    downloadPage = "https://signal.org/download/macos/";
    changelog = "https://github.com/signalapp/Signal-Desktop/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      agpl3Only

      # Various npm packages
      free

      # has non-redistributable Apple emoji packaged, see main derivation
      unfree
    ];
    maintainers = with lib.maintainers; [ nickhu ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
