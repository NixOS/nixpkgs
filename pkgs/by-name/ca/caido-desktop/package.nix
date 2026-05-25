{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  makeWrapper,
  _7zz,
}:

let
  pname = "caido-desktop";
  version = "0.56.0";

  sources = {
    x86_64-linux = {
      url = "https://caido.download/releases/v${version}/caido-desktop-v${version}-linux-x86_64.AppImage";
      hash = "sha256-UA4MPEEnFiiR0ueYoE3H1Z5f7J56NYNahTbWyAImmfQ=";
    };
    aarch64-linux = {
      url = "https://caido.download/releases/v${version}/caido-desktop-v${version}-linux-aarch64.AppImage";
      hash = "sha256-HTegv6UlWe0gID5sGLlUTFc0z6giF7BCIwbCHb/rLjc=";
    };
    x86_64-darwin = {
      url = "https://caido.download/releases/v${version}/caido-desktop-v${version}-mac-x86_64.dmg";
      hash = "sha256-ZnN8DK3OuzZ0rKE+1czFhn2rH8QHJvlgvjc9k3DrV/Q=";
    };
    aarch64-darwin = {
      url = "https://caido.download/releases/v${version}/caido-desktop-v${version}-mac-aarch64.dmg";
      hash = "sha256-XbcmecB4DKPp0WlqBBnc2TvorXEMsDSR5oW/VeUBcVs=";
    };
  };

  src = fetchurl (
    sources.${stdenv.hostPlatform.system}
      or (throw "caido-desktop: unsupported system ${stdenv.hostPlatform.system}")
  );

  meta = {
    description = "Caido Desktop — lightweight web security auditing toolkit";
    homepage = "https://caido.io/";
    changelog = "https://github.com/caido/caido/releases/tag/v${version}";
    license = lib.licenses.unfree;
    mainProgram = "caido-desktop";
    maintainers = with lib.maintainers; [
      blackzeshi
      m0streng0
      octodi
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };

  linux = appimageTools.wrapType2 {
    inherit
      pname
      version
      src
      meta
      ;

    nativeBuildInputs = [ makeWrapper ];
    extraPkgs = pkgs: [ pkgs.libthai ];

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/caido.desktop \
        -t $out/share/applications
      substituteInPlace $out/share/applications/caido.desktop \
        --replace-fail "Exec=AppRun --no-sandbox %U" "Exec=caido-desktop %U"
      install -m 444 -D ${appimageContents}/caido.png \
        $out/share/icons/hicolor/512x512/apps/caido.png
      wrapProgram $out/bin/${pname} \
        --set WEBKIT_DISABLE_COMPOSITING_MODE 1 \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    nativeBuildInputs = [
      _7zz
      makeWrapper
    ];

    unpackPhase = ''
      runHook preUnpack
      7zz x $src || true
      runHook postUnpack
    '';

    sourceRoot = "Caido.app";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications/Caido.app $out/bin
      cp -R . $out/Applications/Caido.app/
      makeWrapper $out/Applications/Caido.app/Contents/MacOS/Caido \
        $out/bin/${pname}
      runHook postInstall
    '';
  };

in
if stdenv.hostPlatform.isLinux then
  linux
else if stdenv.hostPlatform.isDarwin then
  darwin
else
  throw "caido-desktop: unsupported platform ${stdenv.hostPlatform.system}"
