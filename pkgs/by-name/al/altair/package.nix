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
  version = "8.5.0";

  sources = {
    x86_64-linux = fetchurl {
      url = "https://github.com/imolorhe/altair/releases/download/v${version}/altair_${version}_x86_64_linux.AppImage";
      hash = "sha256-ImcnV+Z1J+6wGs3HmlCpXmLb/BbyEcunY+IZ2cbD8Ns=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/imolorhe/altair/releases/download/v${version}/altair_${version}_arm64_mac.dmg";
      hash = "sha256-VXZKYr40TBE1H3NE7yhjxPaReXzJ4c4bhBsXRUnnG7g=";
    };
  };

  meta = {
    description = "Feature-rich GraphQL Client IDE";
    mainProgram = "altair";
    homepage = "https://github.com/imolorhe/altair";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      evalexpr
      kashw2
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };

  appimageContents = appimageTools.extract {
    inherit pname version;
    src = sources.x86_64-linux;
  };

  linux = appimageTools.wrapType2 {
    inherit pname version;

    src = sources.x86_64-linux;

    nativeBuildInputs = [ makeWrapper ];

    extraInstallCommands = ''
      wrapProgram $out/bin/${pname} \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

      install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';

    meta = meta // {
      platforms = lib.intersectLists lib.platforms.linux lib.platforms.x86_64;
    };
  };
  darwin = stdenv.mkDerivation {
    inherit pname version;

    src = sources.aarch64-darwin;

    nativeBuildInputs = [
      _7zz
      makeWrapper
    ];

    sourceRoot = "Altair GraphQL Client.app";

    unpackPhase = ''
      runHook preUnpack
      7zz x $src -x!Altair/Applications
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstallPhase
      mkdir -p $out/{Applications,bin}
      mv Contents $out/Applications
      makeWrapper $out/Applications/Contents/MacOS/Altair\ GraphQL\ Client $out/bin/${pname}
      runHook postInstallPhase
    '';

    meta = meta // {
      platforms = lib.platforms.darwin;
    };
  };
in
if stdenv.isDarwin then darwin else linux
