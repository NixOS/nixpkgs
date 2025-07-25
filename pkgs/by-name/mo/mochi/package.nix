{
  _7zz,
  appimageTools,
  fetchurl,
  lib,
  stdenvNoCC,
  xorg,
  makeWrapper,
}:

let
  pname = "mochi";
  version = "1.19.0";
  appName = "Mochi";

  linux = appimageTools.wrapType2 rec {
    inherit pname version meta;

    src = fetchurl {
      url = "https://mochi.cards/releases/Mochi-${version}.AppImage";
      hash = "";
    };

    appimageContents = appimageTools.extractType2 { inherit pname version src; };

    extraPkgs = pkgs: [ xorg.libxshmfence ];

    extraInstallCommands = ''
      install -Dm444 ${appimageContents}/${pname}.desktop -t $out/share/applications/
      install -Dm444 ${appimageContents}/${pname}.png -t $out/share/pixmaps/
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-fail 'Exec=AppRun --no-sandbox' 'Exec=${pname}'
    '';
  };

  darwin = stdenvNoCC.mkDerivation {
    inherit
      pname
      version
      meta
      appName
      ;

    src = fetchurl {
      url = "https://mochi.cards/releases/Mochi-${version}.dmg";
      hash = "sha256-2y9gwO+l2Hs5+Le87vROYb7Nq2G/gYu0DUHJFfQ+Imw=";
    };

    sourceRoot = "${appName}.app";
    nativeBuildInputs = [
      _7zz
      makeWrapper
    ];

    installPhase = ''
      runHook preInstall

      # 7zz extracts all the entitlements, which trips the signature
      find . -name '*com.apple.cs*' -exec rm {} \;
      mkdir -p $out/{Applications/${appName}.app,bin}
      cp -r . $out/Applications/${appName}.app
      makeWrapper $out/Applications/${appName}.app/Contents/MacOS/${appName} $out/bin/${pname}

      runHook postInstall
    '';

    dontUpdateAutotoolsGnuConfigScripts = true;
    dontConfigure = true;
    dontFixup = true;
  };

  meta = {
    description = "Simple markdown-powered SRS app";
    homepage = "https://mochi.cards/";
    changelog = "https://mochi.cards/changelog.html";
    mainProgram = "mochi";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ poopsicles ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
in
if stdenvNoCC.hostPlatform.isDarwin then darwin else linux
