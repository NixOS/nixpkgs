{
  appimageTools,
  fetchurl,
  lib,
  makeBinaryWrapper,
  python3,
  stdenvNoCC,
  unzip,
}:

let
  pname = "arduino-ide";
  version = "2.3.10";

  inherit (stdenvNoCC.hostPlatform) system;

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://github.com/arduino/arduino-ide/releases/download/${version}/arduino-ide_${version}_Linux_64bit.AppImage";
        hash = "sha256-echZChdEwiDXLL7Q6pHG4qf0WUKSaZsvszZOvXE81WY=";
      };
      aarch64-darwin = fetchurl {
        url = "https://github.com/arduino/arduino-ide/releases/download/${version}/arduino-ide_${version}_macOS_arm64.zip";
        hash = "sha256-GU2Vlv93kAhCrA3UHgfARv5ZtHU/IZaZb0OrLiKRZ90=";
      };
    }
    .${system} or (throw "arduino-ide: ${system} is unsupported.");

  meta = {
    description = "Open-source electronics prototyping platform";
    homepage = "https://www.arduino.cc/en/software";
    changelog = "https://github.com/arduino/arduino-ide/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "arduino-ide";
    maintainers = with lib.maintainers; [
      clerie
      MysteryBlokHed
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
  };

  passthru.updateScript = ./update.sh;

  linux = appimageTools.wrapType2 (finalAttrs: {
    inherit
      pname
      version
      src
      meta
      passthru
      ;

    extraInstallCommands = ''
      install -Dm444 ${finalAttrs.contents}/arduino-ide.desktop -t $out/share/applications/
      install -Dm444 ${finalAttrs.contents}/arduino-ide.png -t $out/share/icons/hicolor/512x512/apps
      substituteInPlace $out/share/applications/arduino-ide.desktop --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=arduino-ide %U'
    '';

    extraPkgs = pkgs: [
      pkgs.libsecret
      (python3.withPackages (ps: [
        ps.pyserial # for esptool
      ]))
    ];
  });

  darwin = stdenvNoCC.mkDerivation (finalAttrs: {
    inherit
      pname
      version
      src
      passthru
      ;

    meta = meta // {
      mainDarwinApp = "Arduino IDE.app";
    };

    nativeBuildInputs = [
      makeBinaryWrapper
      unzip
    ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications $out/bin
      cp -R 'Arduino IDE.app' $out/Applications/
      makeWrapper "$out/Applications/Arduino IDE.app/Contents/MacOS/Arduino IDE" "$out/bin/${finalAttrs.meta.mainProgram}"

      runHook postInstall
    '';

    # Avoid invalidating signature
    dontFixup = true;
  });
in
if stdenvNoCC.hostPlatform.isDarwin then darwin else linux
