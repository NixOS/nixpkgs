{ lib, stdenv, appimageTools, fetchurl, _7zz }:

let
  pname = "notesnook";
  version = "3.0.8";

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
      x86_64-linux = "sha256-H25PGhCD5uqh2BHMMjb7GyftinBsRs2O5+9xNNV+5m4=";
      x86_64-darwin = "sha256-uT4xo4LT70jq7bHmiYu4FL8Fldppc2ai8yEZzGMzM6Q=";
      aarch64-darwin = "sha256-D5KIXHhzXXBOEcoOn2QKKUbVGMWhRW+L7fgxRxLpX/0=";
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
if stdenv.isDarwin
then darwin
else linux
