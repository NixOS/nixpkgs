{
  lib,
  stdenv,
  appimageTools,
  makeWrapper,
  fetchurl,
  _7zz,
}:

let
  pname = "altair";
  version = "8.5.11";

  meta = {
    description = "Feature-rich GraphQL Client IDE";
    mainProgram = "altair";
    homepage = "https://github.com/altair-graphql/altair";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      evalexpr
      kashw2
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };

  linux = appimageTools.wrapType2 (finalAttrs: {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/altair-graphql/altair/releases/download/v${finalAttrs.version}/altair_${finalAttrs.version}_x86_64_linux.AppImage";
      hash = "sha256-WRAlsrDcw/xNwbFvEVvR/ErZa4aynfj8dBRMEVNrI78=";
    };

    nativeBuildInputs = [ makeWrapper ];

    extraInstallCommands = ''
      wrapProgram $out/bin/altair \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

      install -m 444 -D ${finalAttrs.contents}/altair.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/altair.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=altair'
      cp -r ${finalAttrs.contents}/usr/share/icons $out/share
    '';

    meta = meta // {
      platforms = [ "x86_64-linux" ];
    };
  });

  darwin = stdenv.mkDerivation (finalAttrs: {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/altair-graphql/altair/releases/download/v${finalAttrs.version}/altair_${finalAttrs.version}_arm64_mac.dmg";
      hash = "sha256-DtOmDKdlkU/QCAcHNx8Ps7Tx4b767r/3yuf9S07cuxI=";
    };

    nativeBuildInputs = [
      _7zz
      makeWrapper
    ];

    sourceRoot = "Altair GraphQL Client ${finalAttrs.version}-arm64";

    unpackPhase = ''
      runHook preUnpack
      7zz x $src -snld -x!*/Applications
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/{Applications,bin}
      cp -R "Altair GraphQL Client.app" $out/Applications
      makeWrapper "$out/Applications/Altair GraphQL Client.app/Contents/MacOS/Altair GraphQL Client" $out/bin/altair
      runHook postInstall
    '';

    meta = meta // {
      platforms = [ "aarch64-darwin" ];
    };
  });
in
if stdenv.hostPlatform.isDarwin then darwin else linux
