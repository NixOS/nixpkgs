{
  lib,
  stdenv,
  fetchFromCodeberg,
  makeWrapper,
  cmake,
  ninja,
  libarchive,
  libz,
  cef-binary,
  luajit,
  xorg,
  libgbm,
  glib,
  jdk17,
  pango,
  cairo,
  pkg-config,
  libnotify,
  buildFHSEnv,
  makeDesktopItem,
  copyDesktopItems,
  enableRS3 ? false,
}:
let
  cef = cef-binary.override {
    version = "141.0.7";
    gitRevision = "a5714cc";
    chromiumVersion = "141.0.7390.108";

    srcHashes = {
      aarch64-linux = "sha256-2A0hVzUVMBemhjnFE/CrKs4CU96Qkxy8S/SieaEJjwE=";
      x86_64-linux = "sha256-tZzUxeXxbYP8YfIQLbiSyihPcjZM9cd2Ad8gGCSvdGk=";
    };
  };
in
let
  bolt = stdenv.mkDerivation (finalAttrs: {
    pname = "bolt-launcher";
    version = "0.21.0";

    src = fetchFromCodeberg {
      owner = "AdamCake";
      repo = "Bolt";
      tag = finalAttrs.version;
      fetchSubmodules = true;
      hash = "sha256-QQJKUCxeff56ghwP00uF4GI35vSAPWM+JphTEUfWOUo=";
    };

    nativeBuildInputs = [
      cmake
      ninja
      luajit
      makeWrapper
      copyDesktopItems
      pkg-config
    ];

    buildInputs = [
      libgbm
      xorg.libX11
      xorg.libxcb
      libarchive
      libz
      cef
      jdk17
    ];

    cmakeFlags = [
      "-G Ninja"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isAarch64) [
      (lib.cmakeFeature "PROJECT_ARCH" "arm64")
    ];

    preConfigure = ''
      mkdir -p cef
      ln -s ${cef} cef/dist
    '';

    postFixup = ''
      makeWrapper "$out/opt/bolt-launcher/bolt" "$out/bin/${finalAttrs.pname}-${finalAttrs.version}" \
      --set JAVA_HOME ${jdk17}
      mkdir -p $out/lib
      cp $out/usr/local/lib/libbolt-plugin.so $out/lib
      mkdir -p $out/share/icons/hicolor/256x256/apps
      cp ../icon/256.png $out/share/icons/hicolor/256x256/apps/${finalAttrs.pname}.png
    '';

    desktopItems = [
      (makeDesktopItem {
        type = "Application";
        terminal = false;
        name = "Bolt";
        desktopName = "Bolt Launcher";
        genericName = finalAttrs.pname;
        comment = "An alternative launcher for RuneScape";
        exec = "bolt-launcher";
        icon = "bolt-launcher";
        categories = [ "Game" ];
      })
    ];
  });
in
buildFHSEnv {
  inherit (bolt) pname version;

  targetPkgs =
    pkgs:
    [ bolt ]
    ++ (with pkgs; [
      xorg.libSM
      xorg.libXxf86vm
      xorg.libX11
      xorg.libXi
      xorg.libXext
      glib
      pango
      cairo
      gdk-pixbuf
      libz
      libcap
      libsecret
      SDL2
      sdl3
      libGL
      libnotify
    ])
    ++ lib.optionals enableRS3 (
      with pkgs;
      [
        gtk2-x11
        openssl_1_1
      ]
    );

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/256x256/apps

    ln -s ${bolt}/share/applications/*.desktop $out/share/applications/

    ln -s ${bolt}/share/icons/hicolor/256x256/apps/*.png $out/share/icons/hicolor/256x256/apps/
  '';

  runScript = "${bolt.name}";

  meta = {
    homepage = "https://codeberg.org/Adamcake/Bolt";
    changelog = "https://codeberg.org/Adamcake/Bolt/releases/tag/${bolt.version}";
    description = "Alternative launcher for RuneScape";
    longDescription = ''
      Bolt Launcher supports HDOS/RuneLite by default with an optional feature flag for RS3 (enableRS3).
    '';
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      nezia
      jaspersurmont
      iedame
    ];
    platforms = lib.platforms.linux;
    mainProgram = "${bolt.name}";
  };
}
