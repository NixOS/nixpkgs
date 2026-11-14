{
  appimageTools,
  fetchurl,
  lib,
  makeBinaryWrapper,
  stdenvNoCC,
  unzip,
}:

let
  pname = "fire-alpaca";
  version = "2.16.3";
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
      passthru
      meta
      ;

    __structuredAttrs = true;
    strictDeps = true;

    src = fetchurl {
      # Extension lets the unzip setup hook recognize the archive
      name = "FireAlpacaMac_${version}.zip";
      url = "https://web.archive.org/web/20261016042941/https://firealpaca.com/download/mac";
      hash = "sha256-CSLbKHZNsFimOgUy6QA7aS5fFt93KU62hOE2TKDBvjs=";
    };

    nativeBuildInputs = [
      makeBinaryWrapper
      unzip
    ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir --parents "$out"/Applications
      cp --recursive FireAlpaca.app "$out"/Applications
      makeWrapper "$out"/Applications/FireAlpaca.app/Contents/MacOS/FireAlpaca \
        "$out"/bin/${meta.mainProgram}

      runHook postInstall
    '';
  }
else
  appimageTools.wrapType2 rec {
    inherit
      pname
      version
      passthru
      meta
      ;

    src = fetchurl {
      url = "https://web.archive.org/web/20260916202749/https://firealpaca.com/download/linux";
      hash = "sha256-qjK4H2bfTDSAzdqo5clEfWgPBCW/L7A+JDWrSDCPsN8=";
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
  }
