{ stdenv
, lib
, fetchurl
, appimageTools
, makeWrapper
, electron_30
, electronPackage ? electron_30
, asar
}:

let
  electron = electronPackage;
in
stdenv.mkDerivation rec {
  pname = "catalyst";
  version = "3.8.2";

  src = fetchurl {
    url = "https://github.com/CatalystDevOrg/Catalyst/releases/download/v${version}/catalyst-${version}.AppImage";
    hash = "sha256-HHc8oGfYnCDw3HfHBQbl2ibF+/jPoIF8qIRMDoZQV5s=";
    name = "${pname}-${version}.AppImage";
  };

  buildInputs = [
    asar
  ];

  appimageContents = appimageTools.extractType2 {
    name = "${pname}-${version}";
    inherit src;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname} $out/share/applications
    mkdir -p $out/share/${pname}/resources/

    cp -a ${appimageContents}/locales $out/share/${pname}
    cp -a ${appimageContents}/catalyst.desktop $out/share/applications/${pname}.desktop
    cp -a ${appimageContents}/usr/share/icons $out/share
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

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'

    asar pack resources/ $out/share/${pname}/resources/app.asar

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app.asar \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ]}"
  '';

  meta = with lib; {
    description = "A minimal, functional, and customizable user-focused FOSS web browser ";
    homepage = "https://getcatalyst.eu.org";
    license = licenses.mit;
    mainProgram = "catalyst";
    maintainers = with lib.maintainers; [ jdev082 ];
    platforms = [ "x86_64-linux" ];
  };
}
