{
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
  stdenv,
  stdenvNoCC,
  libxshmfence,
  undmg,
}:

let
  pname = "mochi";
  version = "1.20.10";

  linux = appimageTools.wrapType2 rec {
    inherit pname version meta;

    src = fetchurl {
      url = "https://download.mochi.cards/releases/Mochi-${version}.AppImage";
      hash = "sha256-oC53TXgK6UUgsHbLo0Ri/+2/UajYwpoXxHwqO1xY91U=";
    };

    appimageContents = appimageTools.extractType2 { inherit pname version src; };

    extraPkgs = pkgs: [ libxshmfence ];

    extraInstallCommands = ''
      install -Dm444 ${appimageContents}/${pname}.desktop -t $out/share/applications/
      install -Dm444 ${appimageContents}/${pname}.png -t $out/share/pixmaps/
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-fail 'Exec=AppRun --no-sandbox' 'Exec=${pname}'
    '';

    passthru.updateScript = ./update.sh;
  };

  darwin = stdenv.mkDerivation {
    inherit pname version meta;

    src = fetchurl {
      url = "https://download.mochi.cards/releases/Mochi-${version}${lib.optionalString stdenv.hostPlatform.isAarch64 "-arm64"}.dmg";
      hash =
        if stdenv.hostPlatform.isAarch64 then
          "sha256-nLz73G6vthiXex7+y6bLVhe/RvK3fE3UHuzHf8lcilE="
        else
          "sha256-MuvzijF2eDELcSfOyqffKk5tx2a51vU8cGV2/ShSfTg=";
    };

    sourceRoot = ".";

    nativeBuildInputs = [
      makeWrapper
      undmg
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{Applications,bin}
      cp -a Mochi.app $out/Applications
      makeWrapper $out/Applications/Mochi.app/Contents/MacOS/Mochi $out/bin/${pname}

      runHook postInstall
    '';
  };

  meta = {
    description = "Simple markdown-powered SRS app";
    homepage = "https://mochi.cards/";
    changelog = "https://mochi.cards/changelog.html";
    license = lib.licenses.unfree;
    mainProgram = "mochi";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ poopsicles ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
in
if stdenvNoCC.hostPlatform.isDarwin then darwin else linux
