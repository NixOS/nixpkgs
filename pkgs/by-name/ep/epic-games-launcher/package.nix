{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
  autoPatchelfHook,
  wrapGAppsHook3,
  steam,
  webkitgtk_4_1,
  libsoup_3,
  gtk3,
  glib,
  glib-networking,
  cairo,
  gdk-pixbuf,
  libx11,
  libxi,
  dbus,
  libGL,
  libayatana-appindicator,
  gsettings-desktop-schemas,
  gst_all_1,
  extraPkgs ? pkgs: [ ],
  extraLibraries ? pkgs: [ ],
  extraEnv ? { },
}:

let
  pname = "epic-games-launcher";
  version = "0.104.0";
  # Build identifier that upstream appends to the version in the download path
  build = "g2229d5c";

  src = fetchurl {
    url = "https://content-download-egs.distro.on.epicgames.com/Builds/EGLv2/${version}%2B${build}/Linux/EpicGamesLauncher-x86_64.AppImage";
    hash = "sha256-WIgvoOt831GtPL/8rc4uyDawocAlscDyu654VOFInJU=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };

  # Only Epic's binary and the EOS SDK come from the AppImage, all other libraries from nixpkgs.
  # The EOS SDK can't be packaged separately, as it's only downloadable behind a login.
  unwrapped = stdenv.mkDerivation {
    pname = "${pname}-unwrapped";
    inherit version;

    src = appimageContents;

    nativeBuildInputs = [
      autoPatchelfHook
      wrapGAppsHook3
    ];

    buildInputs = [
      webkitgtk_4_1
      libsoup_3
      gtk3
      glib
      glib-networking
      cairo
      gdk-pixbuf
      libx11
      dbus
      gsettings-desktop-schemas
      stdenv.cc.cc.lib
    ]
    ++ (with gst_all_1; [
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
      gst-libav
    ]);

    # Loaded with dlopen
    runtimeDependencies = [
      libayatana-appindicator
      libGL
      libxi
    ];

    installPhase = ''
      runHook preInstall

      install -Dm755 usr/bin/EpicGamesLauncher -t $out/bin
      install -Dm755 usr/lib/libEOSSDK-Linux-Shipping.so -t $out/lib
      cp -r usr/lib/epic-games-launcher $out/lib/

      runHook postInstall
    '';
  };
in
# Windows games run through GE-Proton, which the launcher downloads itself.
# Its `proton` script is `#!/usr/bin/env python3` and needs the same
# multiarch FHS as Steam, so use Steam's runtime env like `heroic` does.
steam.buildRuntimeEnv {
  inherit pname version;

  # A subset of the env `heroic` used before switching to `umu-run`.
  # Only 64-bit, since the launcher sets PROTON_USE_WOW64.
  extraPkgs =
    pkgs:
    with pkgs;
    [
      python3
      xrandr
      gamemode
      mangohud
      SDL2
      libxcomposite
      libxxf86vm
      libgcrypt
    ]
    ++ extraPkgs pkgs;
  inherit extraLibraries;

  extraEnv = {
    EGL_DISABLE_SELF_UPDATE = "1";
  }
  // extraEnv;

  runScript = "${unwrapped}/bin/EpicGamesLauncher";

  privateTmp = false;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/usr/share/applications/epic-games-launcher.desktop \
      -t $out/share/applications
    substituteInPlace $out/share/applications/epic-games-launcher.desktop \
      --replace-fail 'Exec=EpicGamesLauncher' 'Exec=epic-games-launcher'

    for size in 32x32 128x128 256x256@2; do
      install -Dm444 ${appimageContents}/usr/share/icons/hicolor/$size/apps/EpicGamesLauncher.png \
        -t $out/share/icons/hicolor/$size/apps
    done
  '';

  passthru = {
    inherit src unwrapped;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Desktop client for the Epic Games Store";
    longDescription = ''
      Extra packages can be added to the runtime env games run in, for less common
      GE-Proton features or native Linux games:
      ```nix
      pkgs.epic-games-launcher.override {
        extraPkgs = pkgs: with pkgs; [
          samba4 # ntlm_auth, netapi
          unixODBC
          cabextract unzip p7zip # winetricks
          openal alsa-plugins # native Linux games
        ];
      }
      ```
      For a broader set, see the env `heroic` used before switching to `umu-run`:
      https://github.com/NixOS/nixpkgs/blob/55432fae0e465683ea71bc18bd43334471ca0e0f/pkgs/by-name/he/heroic/package.nix
    '';
    homepage = "https://launcher.epicgames.com/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ no-mood ];
    mainProgram = "epic-games-launcher";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
