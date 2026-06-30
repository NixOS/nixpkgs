{
  appimageTools,
  fetchurl,
  lib,
  stdenvNoCC,
  unzip,
}:

let
  baseUrl = "https://web.archive.org/web/20260622062138/https://firealpaca.com/download/";

  pname = "fire-alpaca";
  version = "2.16.0";
  __structuredAttrs = true;
  strictDeps = true;
  passthru.updateScript = ./update.sh;
  meta = {
    description = "Digital painting software";
    longDescription = ''
      FireAlpaca is a freeware paint tool that has been used
      worldwide, supports 10 languages.
    '';
    homepage = "https://firealpaca.com";
    license = lib.licenses.unfree;
    mainProgram = "fire-alpaca";
    maintainers = with lib.maintainers; [ yiyu ];
    platforms = [
      "aarch64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
in
if stdenvNoCC.hostPlatform.system == "aarch64-darwin" then
  stdenvNoCC.mkDerivation {
    inherit
      pname
      version
      __structuredAttrs
      strictDeps
      passthru
      meta
      ;

    src = fetchurl {
      url = "${baseUrl}mac";
      hash = "sha256-hium+wJESzkgV0X2gf5fyNImI8ss9W8MWGi1Pk2mIY8=";
    };

    nativeBuildInputs = [ unzip ];

    unpackPhase = ''
      runHook preUnpack

      unzip "$src"

      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      mkdir --parents "$out"/Applications
      cp --recursive FireAlpaca.app "$_"

      runHook postInstall
    '';
  }
else if stdenvNoCC.hostPlatform.system == "x86_64-linux" then
  (appimageTools.wrapType2 rec {
    inherit
      pname
      version
      passthru
      meta
      ;

    src = fetchurl {
      url = "${baseUrl}linux";
      hash = "sha256-kPW1pPPr1HIAZNrJJhieiaT2g6aMMbvbHhFTuzxviX8=";
    };

    extraInstallCommands =
      let
        appimageContents = appimageTools.extract {
          inherit pname version src;
        };
      in
      ''
        install -Dm444 ${appimageContents}/FireAlpaca.desktop \
          --target-directory="$out"/share/applications

        substituteInPlace "$out"/share/applications/FireAlpaca.desktop \
          --replace-fail Exec=FireAlpaca Exec=${meta.mainProgram}

        cp --recursive ${appimageContents}/usr/share/icons $out/share
      '';
  }).overrideAttrs
    (oldAttrs: {
      inherit __structuredAttrs strictDeps;
    })
else
  { }
