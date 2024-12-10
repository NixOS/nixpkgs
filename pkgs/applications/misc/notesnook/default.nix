{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
  undmg,
}:

let
  pname = "notesnook";
  version = "2.6.1";

  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  suffix =
    {
      x86_64-linux = "linux_x86_64.AppImage";
      x86_64-darwin = "mac_x64.dmg";
      aarch64-darwin = "mac_arm64.dmg";
    }
    .${system} or throwSystem;

  src = fetchurl {
    url = "https://github.com/streetwriters/notesnook/releases/download/v${version}/notesnook_${suffix}";
    hash =
      {
        x86_64-linux = "sha256-PLHP1Q4+xcHyr0323K4BD+oH57SspsrAcxRe/C6RFDU=";
        x86_64-darwin = "sha256-gOUL3qLSM+/pr519Gc0baUtbmhA40lG6XzuCRyGILkc=";
        aarch64-darwin = "sha256-d1nXdCv1mK4+4Gef1upIkHS3J2d9qzTLXbBWabsJwpw=";
      }
      .${system} or throwSystem;
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

  meta = with lib; {
    description = "A fully open source & end-to-end encrypted note taking alternative to Evernote.";
    longDescription = ''
      Notesnook is a free (as in speech) & open source note taking app
      focused on user privacy & ease of use. To ensure zero knowledge
      principles, Notesnook encrypts everything on your device using
      XChaCha20-Poly1305 & Argon2.
    '';
    homepage = "https://notesnook.com";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ j0lol ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "notesnook";
  };

  linux = appimageTools.wrapType2 rec {
    inherit
      pname
      version
      src
      meta
      ;

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
    inherit
      pname
      version
      src
      meta
      ;

    nativeBuildInputs = [ undmg ];

    sourceRoot = "Notesnook.app";

    installPhase = ''
      mkdir -p $out/Applications/Notesnook.app
      cp -R . $out/Applications/Notesnook.app
    '';
  };
in
if stdenv.isDarwin then darwin else linux
