{
  lib,
  stdenv,
  fetchurl,
  buildFHSEnv,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  alsa-lib,
  at-spi2-atk,
  cairo,
  cups,
  dbus,
  expat,
  gdk-pixbuf,
  glib,
  gtk3,
  libgbm,
  libGL,
  nss,
  nspr,
  libdrm,
  libxrandr,
  libxfixes,
  libxext,
  libxdamage,
  libxcomposite,
  libx11,
  libxkbfile,
  libxcb,
  libxkbcommon,
  libxshmfence,
  pango,
  systemd,
  icu,
  openssl,
  zlib,
  bintools,
}:
let
  pname = "sidequest";
  version = "1.4.1";

  sidequest = stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/SideQuestVR/SideQuest/releases/download/v${version}/SideQuest-${version}.tar.xz";
      hash = "sha256-R0jE3sr3QRBffGiVE1oNaYmg0irHVmS67Bb/WOLP5I4=";
    };

    nativeBuildInputs = [
      copyDesktopItems
      makeWrapper
    ];

    desktopItems = [
      (makeDesktopItem {
        name = "sidequest";
        exec = "sidequest";
        icon = "sidequest";
        desktopName = "SideQuest";
        genericName = "VR App Store";
        categories = [
          "Settings"
          "PackageManager"
        ];
      })
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/libexec" "$out/bin"
      cp --recursive . "$out/libexec/sidequest"
      ln -s "$out/libexec/sidequest/sidequest" "$out/bin/sidequest"
      install -Dm644 resources/icon.png $out/share/icons/hicolor/512x512/apps/sidequest.png

      runHook postInstall
    '';

    postFixup = ''
      patchelf \
        --set-interpreter "${bintools.dynamicLinker}" \
        --set-rpath "${
          lib.makeLibraryPath [
            alsa-lib
            at-spi2-atk
            cairo
            cups
            dbus
            expat
            gdk-pixbuf
            glib
            gtk3
            libgbm
            libGL
            nss
            nspr
            libdrm
            libx11
            libxcb
            libxcomposite
            libxdamage
            libxext
            libxfixes
            libxrandr
            libxshmfence
            libxkbcommon
            libxkbfile
            pango
            (lib.getLib stdenv.cc.cc)
            systemd
          ]
        }:$out/libexec/sidequest" \
        --add-needed libGL.so.1 \
        "$out/libexec/sidequest/sidequest"
    '';
  };
in
buildFHSEnv {
  inherit pname version;

  targetPkgs = pkgs: [
    sidequest
    # Needed in the environment on runtime, to make QuestSaberPatch work
    icu
    openssl
    zlib
    libxkbcommon
    libxshmfence
  ];

  extraInstallCommands = ''
    ln -s ${sidequest}/share "$out/share"
  '';

  runScript = "sidequest";

  meta = {
    description = "Open app store and side-loading tool for Android-based VR devices such as the Oculus Go, Oculus Quest or Moverio BT 300";
    homepage = "https://github.com/SideQuestVR/SideQuest";
    downloadPage = "https://github.com/SideQuestVR/SideQuest/releases";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      joepie91
      rvolosatovs
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "sidequest";
    knownVulnerabilities = [
      "Uses EOL Electron 29, many known CVEs."
    ];
  };
}
