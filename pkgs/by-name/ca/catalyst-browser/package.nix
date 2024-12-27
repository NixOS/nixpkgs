{
  stdenv,
  lib,
  fetchurl,
  appimageTools,
  makeWrapper,
  electron_33,
  electronPackage ? electron_33,
  asar,
}:

let
  electron = electronPackage;
in
stdenv.mkDerivation rec {
  pname = "catalyst-browser";
  version = "3.9.5";

  src = fetchurl {
    url = "https://github.com/CatalystDevOrg/Catalyst/releases/download/v${version}/catalyst-${version}.AppImage";
    hash = "sha256-7lODV9qbl3gcJ5v/0EiJ2IgGCW7pY6RQFlMzClGt2DU=
";
    name = "catalyst-${version}.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname src version;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
    asar
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/catalyst $out/share/applications
    mkdir -p $out/share/catalyst/resources/

    cp -a ${appimageContents}/locales $out/share/catalyst
    cp -a ${appimageContents}/catalyst.desktop $out/share/applications/catalyst.desktop
    mkdir -p $out/share/pixmaps
    cp -r ${appimageContents}/usr/share/icons/hicolor/1080x1080/apps/catalyst.png $out/share/pixmaps/
    asar extract ${appimageContents}/resources/app.asar resources/
    rm -rf resources/.github
    rm -rf resources/.vscode
    rm -rf resources/.eslintrc.json
    rm -rf resources/.gitignore
    rm -rf resources/.pnpm-debug.log
    rm -rf resources/contributing.md
    rm -rf resources/pnpm-lock.yaml
    rm -rf resources/README.md
    rm -rf resources/CODE_OF_CONDUCT.md
    rm -rf *.nix
    substituteInPlace resources/src/index.html \
      --replace-fail 'catalyst-default-distrib' 'catalyst-default-nixpkgs'

    substituteInPlace $out/share/applications/catalyst.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${meta.mainProgram}'

    asar pack resources/ $out/share/catalyst/resources/app.asar

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${meta.mainProgram} \
      --add-flags $out/share/catalyst/resources/app.asar \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ]}"
  '';

  meta = {
    description = "Minimal, functional, and customizable user-focused FOSS web browser based on Chromium";
    homepage = "https://getcatalyst.eu.org";
    license = lib.licenses.mit;
    mainProgram = "catalyst";
    maintainers = with lib.maintainers; [ jdev082 ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
