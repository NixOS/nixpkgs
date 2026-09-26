{
  appimageTools,
  lib,
  fetchurl,
  stdenvNoCC,
  makeWrapper,
  _7zz,
}:

let
  pname = "electron-mail";
  version = "5.3.9";

  sources = {
    x86_64-linux = fetchurl {
      url = "https://github.com/vladimiry/ElectronMail/releases/download/v${version}/electron-mail-${version}-linux-x86_64.AppImage";
      hash = "sha256-hZxcodnfQ4iyLaXE04QgIjOJs+3NJ7Ukckk71DqnRy0=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/vladimiry/ElectronMail/releases/download/v${version}/electron-mail-${version}-mac-arm64.dmg";
      hash = "sha256-2CRUEif7UMsZgDWw3HiUEip68wXd0AUPPHdo712ZnYc=";
    };
  };

  src = sources.${stdenvNoCC.hostPlatform.system};

  appimageContents = appimageTools.extract {
    inherit src pname version;
  };

  meta = {
    description = "Unofficial Election-based ProtonMail desktop client";
    mainProgram = "electron-mail";
    homepage = "https://github.com/vladimiry/ElectronMail";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      princemachiavelli
      BatteredBunny
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    changelog = "https://github.com/vladimiry/ElectronMail/releases/tag/v${version}";
  };

  linux = appimageTools.wrapType2 {
    inherit
      src
      pname
      version
      meta
      ;

    passthru.updateScript = ./update.sh;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';

    extraPkgs = pkgs: [
      pkgs.libsecret
      pkgs.libappindicator
    ];
  };

  darwin = stdenvNoCC.mkDerivation {
    inherit
      src
      pname
      version
      meta
      ;

    passthru.updateScript = ./update.sh;

    sourceRoot = ".";
    nativeBuildInputs = [
      _7zz
      makeWrapper
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r *.app $out/Applications/
      makeWrapper "$out/Applications/electron-mail.app/Contents/MacOS/electron-mail" $out/bin/${pname}

      runHook postInstall
    '';
  };
in
if stdenvNoCC.hostPlatform.isDarwin then darwin else linux
