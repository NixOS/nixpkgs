{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
  makeWrapper,
  _7zz,
}:

let
  pname = "notesnook";
  version = "3.3.8";

  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  suffix =
    {
      x86_64-linux = "linux_x86_64.AppImage";
      aarch64-linux = "linux_arm64.AppImage";
      x86_64-darwin = "mac_x64.dmg";
      aarch64-darwin = "mac_arm64.dmg";
    }
    .${system} or throwSystem;

  src = fetchurl {
    url = "https://github.com/streetwriters/notesnook/releases/download/v${version}/notesnook_${suffix}";
    hash =
      {
        x86_64-linux = "sha256-7gPCmC3uol5ukwu8OOhhqk9pBTgWjI14wYmM61nlg+A=";
        aarch64-linux = "sha256-JmWt7yr/Ij01x7bTWUQ7UAwKcEf9i91fZZsHpEWRJYY=";
        x86_64-darwin = "sha256-5Obl3YveMx38sdLIGRz3Lqi3mloruTyH/3MsNNX03TA=";
        aarch64-darwin = "sha256-P1xqMFGAQQVq76O1RTp+3kZtzM1xGvSUpbki64KTji8=";
      }
      .${system} or throwSystem;
  };

  passthru = {
    updateScript = ./update.sh;
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

  meta = {
    description = "Fully open source & end-to-end encrypted note taking alternative to Evernote";
    longDescription = ''
      Notesnook is a free (as in speech) & open source note taking app
      focused on user privacy & ease of use. To ensure zero knowledge
      principles, Notesnook encrypts everything on your device using
      XChaCha20-Poly1305 & Argon2.
    '';
    homepage = "https://notesnook.com";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      keysmashes
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
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
      passthru
      ;

    nativeBuildInputs = [ makeWrapper ];

    profile = ''
      export LC_ALL=C.UTF-8
    '';

    extraInstallCommands = ''
      wrapProgram $out/bin/notesnook \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
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
      passthru
      ;

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
if stdenv.hostPlatform.isDarwin then darwin else linux
