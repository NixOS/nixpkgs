{
  lib,
  stdenv,
  runCommand,
  megacmd,
  unzip,
  makeWrapper,
  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
  libgcc,
  cairo,
  dbus,
  xorg_sys_opengl,
  systemd,
  libcap,
  libdrm,
  pulseaudio,
  libsndfile,
  flac,
  glib,
  libvorbis,
  libopus,
  mpg123,
  lame,
  libGL,
  vulkan-loader,
  libasyncns,
  pango,
  xorg,
  wayland,
}:

let
  pname = "legends-of-equestria";
  version = "2025.05.001";
  description = "Free-to-play MMORPG";

  srcOptions = {
    x86_64-linux = {
      url = "https://mega.nz/file/cjhDAZ5S#dsCHHfZ3rhmGBynu4FxooK5kf2w7oHYwgzf4E7vzerM";
      outputHash = "WbJL/+T/BNrk4GllCM4C4K2OymHmjzf5BuFR4V1N5Ds=";
    };
    x86_64-darwin = {
      url = "https://mega.nz/file/dqQyjaSC#Aazc0tyu3v5WZcGet8ouHWlBB4to6Eu1SADYa3iSmAw";
      outputHash = "V8qGABS1uNnj/0CVLsFNXLjzBAjq/UXAT11gczVP298=";
    };
    aarch64-darwin = {
      url = "https://mega.nz/file/I6QCSZqL#by23SjXBl0EMtgxex9Fhv5FO4qkhFX4uWSr3l5N4f-M";
      outputHash = "ISmtCw35kA4p6nWcDWIk4UucVT7fIGS9XC73rzwSigo=";
    };
  };

  runtimeDeps = [
    dbus.lib
    xorg_sys_opengl
    systemd
    libcap.lib
    libdrm
    pulseaudio
    libsndfile
    flac
    libvorbis
    mpg123
    lame.lib
    libGL
    vulkan-loader
    libasyncns
  ]
  ++ (with xorg; [
    libX11
    libxcb
    libXau
    libXdmcp
    libXext
    libXcursor
    libXrender
    libXfixes
    libXinerama
    libXi
    libXrandr
    libXScrnSaver
  ]);
in
stdenv.mkDerivation {
  inherit pname version;
  src =
    runCommand "mega-loe"
      (
        srcOptions.${stdenv.hostPlatform.system}
        // {
          pname = "${pname}-source";
          inherit version;
          nativeBuildInputs = [
            megacmd
            unzip
          ];
          outputHashAlgo = "sha256";
          outputHashMode = "recursive";
        }
      )
      ''
        export HOME=$(mktemp -d)
        dest=$HOME/mega-loe
        mkdir -p $dest
        mega-get "$url" $dest
        mkdir -p $out
        unzip -d $out $dest/*.zip
      '';

  dontBuild = true;
  buildInputs = [
    libgcc
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    cairo
    dbus
    glib
    pango
    wayland
  ];
  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
    autoPatchelfHook
  ];

  installPhase =
    if stdenv.hostPlatform.isLinux then
      ''
        runHook preInstall

        loeHome=$out/lib/${pname}
        mkdir -p $loeHome
        cp -r LoE/* $loeHome

        chmod +x $loeHome/LoE.x86_64
        makeWrapper $loeHome/LoE.x86_64 $out/bin/LoE \
          --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeDeps}"

        icon=$out/share/icons/hicolor/128x128/apps/legends-of-equestria.png
        mkdir -p $(dirname $icon)
        ln -s $loeHome/LoE_Data/Resources/UnityPlayer.png $icon

        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        mkdir -p $out/Applications
        cp -r *.app $out/Applications

        runHook postInstall
      '';

  passthru.updateScript = ./update.sh;

  desktopItems = [
    (makeDesktopItem {
      name = "legends-of-equestria";
      comment = description;
      desktopName = "Legends of Equestria";
      genericName = "Legends of Equestria";
      exec = "LoE";
      icon = "legends-of-equestria";
      categories = [ "Game" ];
    })
  ];

  meta = {
    inherit description;
    license = lib.licenses.unfree;
    platforms = lib.attrNames srcOptions;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    mainProgram = "LoE";
    homepage = "https://www.legendsofequestria.com";
    downloadPage = "https://www.legendsofequestria.com/downloads";
  };

}
