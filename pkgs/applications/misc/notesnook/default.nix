{ lib, stdenv, appimageTools, fetchurl, _7zz }:

let
  pname = "notesnook";
  version = "3.0.16";

  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  suffix = {
    x86_64-linux = "linux_x86_64.AppImage";
    x86_64-darwin = "mac_x64.dmg";
    aarch64-darwin = "mac_arm64.dmg";
  }.${system} or throwSystem;

  src = fetchurl {
    url = "https://github.com/streetwriters/notesnook/releases/download/v${version}/notesnook_${suffix}";
    hash = {
      x86_64-linux = "sha256-HywWk3MAWdRVaQyimlQJCFsgydXdE0VSLWliZT7f8w0=";
      x86_64-darwin = "sha256-GgZVVt1Gm95/kyI/q99fZ9BIN+5kpxumcSJ9BexfARc=";
      aarch64-darwin = "sha256-ldg+bVROm/XzACCmiMapMQf3f6le9FHzt18QcaH8TxA=";
    }.${system} or throwSystem;
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

  meta = with lib; {
    description = "Fully open source & end-to-end encrypted note taking alternative to Evernote";
    longDescription = ''
      Notesnook is a free (as in speech) & open source note taking app
      focused on user privacy & ease of use. To ensure zero knowledge
      principles, Notesnook encrypts everything on your device using
      XChaCha20-Poly1305 & Argon2.
    '';
    homepage = "https://notesnook.com";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ cig0 j0lol ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
    mainProgram = "notesnook";
  };

  linux = appimageTools.wrapType2 rec {
    inherit pname version src meta;

    profile = ''
      export LC_ALL=C.UTF-8
    '';

    extraInstallCommands = ''
      install -Dm444 ${appimageContents}/notesnook.desktop -t $out/share/applications
      install -Dm444 ${appimageContents}/notesnook.png -t $out/share/pixmaps
      substituteInPlace $out/share/applications/notesnook.desktop \
        --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${pname}'
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ _7zz ];

    sourceRoot = "Notesnook.app";

    # 7zz did not unpack in setup hook for some reason, done manually here
    unpackPhase = ''
      7zz x $src
    '';

    installPhase = ''
      mkdir -p $out/Applications/Notesnook.app
      cp -R . $out/Applications/Notesnook.app
    '';
  };
in
if stdenv.hostPlatform.isDarwin
then darwin
else linux
