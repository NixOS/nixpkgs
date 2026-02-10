{
  appimageTools,
  lib,
  fetchurl,
  nix-update-script,
  stdenvNoCC,
  makeWrapper,
  undmg,
}:

let
  pname = "electron-mail";
  version = "5.3.5";

  sources = {
    x86_64-linux = fetchurl {
      url = "https://github.com/vladimiry/ElectronMail/releases/download/v${version}/electron-mail-${version}-linux-x86_64.AppImage";
      hash = "sha256-xlDk/MwDs1DKzIx+8NyrS+yQw4u3gY5iTXvc2NWLn8s=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/vladimiry/ElectronMail/releases/download/v${version}/electron-mail-${version}-mac-arm64.dmg";
      hash = "sha256-5g/6ndODuK1OkeI2+DwYTZoDdgM+/qMYMgrFhHRPnAI=";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/vladimiry/ElectronMail/releases/download/v${version}/electron-mail-${version}-mac-x64.dmg";
      hash = "sha256-qjqND/H5ng2gG+llZ1aM2ju8ITHPfMVZTzDdqN0lhnU=";
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
      "x86_64-darwin"
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

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';

    extraPkgs = pkgs: [
      pkgs.libsecret
      pkgs.libappindicator-gtk3
    ];

    passthru.updateScript = nix-update-script { };
  };

  darwin = stdenvNoCC.mkDerivation {
    inherit
      src
      pname
      version
      meta
      ;

    sourceRoot = ".";
    nativeBuildInputs = [
      undmg
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
