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
  libxxf86vm,
  libxi,
  libxext,
  libx11,
  libsm,
  libxcb,
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
  nix-update-script,
  # Extra packages for the FHS environment, e.g. the libraries the RS3 client
  # needs, see https://wiki.nixos.org/wiki/Bolt-launcher
  extraPkgs ? pkgs: [ ],
  enableRS3 ? false,
}:
assert lib.assertMsg (!enableRS3) ''
  bolt-launcher: `enableRS3` has been removed, as the RS3 client needs OpenSSL 1.1
  and GTK 2, which are end of life. To use RS3, add `openssl_1_1` and `gtk2-x11`
  from nixos-26.05 with `extraPkgs`.
'';
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
    version = "0.24.0";

    src = fetchFromCodeberg {
      owner = "AdamCake";
      repo = "Bolt";
      tag = finalAttrs.version;
      fetchSubmodules = true;
      hash = "sha256-z/0rurPX/Om1sXkA3pGcmmbCPk8CONV70eBHGT5nuoc=";
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
      libx11
      libxcb
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
        startupWMClass = "BoltLauncher";
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
      libsm
      libxxf86vm
      libx11
      libxi
      libxext
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
    ++ extraPkgs pkgs;

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/256x256/apps

    ln -s ${bolt}/share/applications/*.desktop $out/share/applications/

    ln -s ${bolt}/share/icons/hicolor/256x256/apps/*.png $out/share/icons/hicolor/256x256/apps/
  '';

  passthru = {
    inherit (bolt) src;
    unwrapped = bolt;
    updateScript = nix-update-script { };
  };

  runScript = "${bolt.name}";

  meta = {
    homepage = "https://codeberg.org/Adamcake/Bolt";
    changelog = "https://codeberg.org/Adamcake/Bolt/releases/tag/${bolt.version}";
    description = "Alternative launcher for RuneScape";
    longDescription = ''
      Bolt Launcher supports HDOS/RuneLite. The RS3 client needs end-of-life
      libraries (OpenSSL 1.1, GTK 2), which can be added with `extraPkgs`.
    '';
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      nezia
      jaspersurmont
      iedame
    ];
    platforms = lib.platforms.linux;
    mainProgram = "bolt-launcher";
  };
}
