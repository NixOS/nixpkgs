{
  lib,
  stdenv,
  fetchurl,
  dpkg,
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
  version = "0.122.0";
  # Build identifier that upstream appends to the version in the download path
  build = "g2109121";

  src = fetchurl {
    url = "https://content-download-egs.distro.on.epicgames.com/Builds/EGLv2/${version}%2B${build}/Linux/EpicGamesLauncher-x86_64.deb";
    hash = "sha256-EVmUJ1njL9zMUloqTJmPjMTnzXYgrM5QGt4kLVCO+RU=";
  };

  # The EOS SDK can't be packaged separately, as it's only downloadable behind a login.
  unwrapped = stdenv.mkDerivation {
    pname = "${pname}-unwrapped";
    inherit version;

    inherit src;

    nativeBuildInputs = [
      dpkg
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

      mkdir -p $out
      cp -r usr/{bin,lib,share} $out/
      rm -r $out/share/doc
      substituteInPlace $out/share/applications/epic-games-launcher.desktop \
        --replace-fail 'Exec=EpicGamesLauncher' 'Exec=epic-games-launcher'

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
  # Only 64-bit, since PROTON_USE_WOW64 is set below.
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
    # The env only provides 64-bit libraries, which is all Wine's new WoW64 mode needs.
    # The launcher doesn't always enable it by itself.
    PROTON_USE_WOW64 = "1";
  }
  // extraEnv;

  runScript = "${unwrapped}/bin/EpicGamesLauncher";

  privateTmp = false;

  extraInstallCommands = ''
    mkdir -p $out/share
    ln -s ${unwrapped}/share/applications $out/share
    ln -s ${unwrapped}/share/icons $out/share
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
        ];
        # To let the launcher decide whether to use WoW64, which then needs
        # 32-bit libraries through `extraLibraries`:
        # extraEnv.PROTON_USE_WOW64 = "0";
      }
      ```
      For a broader set, see the env `heroic` used before switching to `umu-run`
      (its `multiPkgs` go in `extraLibraries`):
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
