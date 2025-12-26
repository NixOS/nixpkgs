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
  xorg,
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
  version = "0.10.42";

  sidequest = stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/SideQuestVR/SideQuest/releases/download/v${version}/SideQuest-${version}.tar.xz";
      hash = "sha256-YZp7OAjUOXepVv5dPhh9Q2HicUKjSOGfhrWyMKy2gME=";
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
      for size in 16 24 32 48 64 128 256 512 1024; do
        install -D --mode=0644 resources/app.asar.unpacked/build/icons/''${size}x''${size}.png $out/share/icons/hicolor/''${size}x''${size}/apps/sidequest.png
      done

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
            xorg.libX11
            xorg.libxcb
            xorg.libXcomposite
            xorg.libXdamage
            xorg.libXext
            xorg.libXfixes
            xorg.libXrandr
            xorg.libxshmfence
            libxkbcommon
            xorg.libxkbfile
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
    mainProgram = "SideQuest";
  };
}
