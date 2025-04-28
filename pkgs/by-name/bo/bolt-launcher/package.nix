{
  lib,
  stdenv,
  fetchFromGitHub,
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
  buildFHSEnv,
  makeDesktopItem,
  copyDesktopItems,
  enableRS3 ? false,
}:
let
  cef = cef-binary.overrideAttrs (oldAttrs: {
    version = "126.2.18";
    gitRevision = "3647d39";
    chromiumVersion = "126.0.6478.183";

    srcHash =
      {
        aarch64-linux = "sha256-Ni5aEbI+WuMnbT8gPWMONN5NkTySw7xJvnM6U44Njao=";
        x86_64-linux = "sha256-YwND4zsndvmygJxwmrCvaFuxjJO704b6aDVSJqpEOKc=";
      }
      .${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
  });
in
let
  bolt = stdenv.mkDerivation (finalAttrs: {
    pname = "bolt-launcher";
    version = "0.15.0";

    src = fetchFromGitHub {
      owner = "AdamCake";
      repo = "bolt";
      tag = finalAttrs.version;
      fetchSubmodules = true;
      hash = "sha256-zEExwQRzDmV0xd3lcxFE2ZVfkyTFYZQe3/c0IWJ9C/c=";
    };

    nativeBuildInputs = [
      cmake
      ninja
      luajit
      makeWrapper
      copyDesktopItems
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
      "-D CMAKE_BUILD_TYPE=Release"
      "-D BOLT_LUAJIT_INCLUDE_DIR=${luajit}/include"
      "-G Ninja"
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
      glib
      pango
      cairo
      gdk-pixbuf
      libz
      libcap
      libsecret
      SDL2
      libGL
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
    homepage = "https://github.com/Adamcake/Bolt";
    description = "An alternative launcher for RuneScape.";
    longDescription = ''
      Bolt Launcher supports HDOS/RuneLite by default with an optional feature flag for RS3 (enableRS3).
    '';
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ nezia ];
    platforms = lib.platforms.linux;
    mainProgram = "${bolt.name}";
  };
}
