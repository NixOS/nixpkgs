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
  version = "2025.04.001";
  description = "Free-to-play MMORPG";

  srcOptions = {
    x86_64-linux = {
      url = "https://mega.nz/file/w7BQTCAD#zW1atRLzSd1-V8GV7s7yj_HVZwB4v8zuX3aWIjA0ztc";
      outputHash = "YYPxS/qNl/DvNmiGZorRGoONbtAI3nJslqCRzctwoz8=";
    };
    x86_64-darwin = {
      url = "https://mega.nz/file/IqgBEJTD#aUd6LgigncoQ8o3owSkadYRp7GkfIOWl4B1Hwzti1qk";
      outputHash = "XdcHM6zCDNFU5VJo3/QISuhtYnBKm1f6IEDfy6Fjnp8=";
    };
    aarch64-darwin = {
      url = "https://mega.nz/file/QyZnkYYB#EtAZrVdHgqX10ag09M9nhJVEboG0J_5f_nVKxCHskYg";
      outputHash = "GA0Zin+vlgYfBFC1ZbkkgX1eSn/NVBYuxuv8fayXMLU=";
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
