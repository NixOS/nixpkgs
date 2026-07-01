{
  appimageTools,
  lib,
  fetchurl,
  stdenv,
  stdenvNoCC,
  undmg,
  makeWrapper,
}:

let
  sources = import ./sources.nix { inherit fetchurl; };
  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  pname = "snipaste";
  inherit (source) version src;

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    description = "Screenshot tools";
    homepage = "https://www.snipaste.com/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      ltrump
    ];
    mainProgram = "snipaste";
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
in
if stdenv.hostPlatform.isDarwin then
  stdenvNoCC.mkDerivation {
    inherit
      pname
      version
      src
      passthru
      meta
      ;

    nativeBuildInputs = [
      undmg
      makeWrapper
    ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications $out/bin
      cp -R Snipaste.app $out/Applications
      makeWrapper $out/Applications/Snipaste.app/Contents/MacOS/Snipaste $out/bin/snipaste

      runHook postInstall
    '';
  }
else
  let
    contents = appimageTools.extract { inherit pname version src; };
  in
  appimageTools.wrapType2 {
    inherit
      pname
      version
      src
      passthru
      meta
      ;

    extraInstallCommands = ''
      install -d $out/share/{applications,icons}
      install -m 444 ${contents}/Snipaste.desktop $out/share/applications/${pname}.desktop
      cp -r ${contents}/usr/share/icons/* -t $out/share/icons/
      substituteInPlace $out/share/applications/${pname}.desktop --replace-warn 'Exec=Snipaste' 'Exec=${pname}'
    '';
  }
