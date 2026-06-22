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
  version = "0.56.2";

  sources = {
    x86_64-linux = {
      url = "https://caido.download/releases/v${version}/caido-desktop-v${version}-linux-x86_64.AppImage";
      hash = "sha256-GW8prdvR9+WNO7bdz9ok27Aqra9+jgpZyBnYIM+G5Ys=";
    };
    aarch64-linux = {
      url = "https://caido.download/releases/v${version}/caido-desktop-v${version}-linux-aarch64.AppImage";
      hash = "sha256-mN5wf9RUllfbR/CfLTE6Ywzoj8wKmEG1clVCKRqPUtU=";
    };
    x86_64-darwin = {
      url = "https://caido.download/releases/v${version}/caido-desktop-v${version}-mac-x86_64.dmg";
      hash = "sha256-4B3DQJL8M6otnLpFjr4haZA4EWHpgVADQW4DcwsDhIM=";
    };
    aarch64-darwin = {
      url = "https://caido.download/releases/v${version}/caido-desktop-v${version}-mac-aarch64.dmg";
      hash = "sha256-kZdfcZueMmgEHpNTIPANsN7X4lnVOfZXbKHxComaalM=";
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
