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
  dbus,
  xorg_sys_opengl,
  systemd,
  libcap,
  libdrm,
  pulseaudio,
  libsndfile,
  flac,
  libvorbis,
  libopus,
  mpg123,
  lame,
  libGL,
  vulkan-loader,
  libasyncns,
  xorg,
}:

let
  pname = "legends-of-equestria";
  version = "2024.05.01";
  description = "Free-to-play MMORPG";
  runtimeDeps =
    [
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
      {
        inherit pname version;
        nativeBuildInputs = [
          megacmd
          unzip
        ];
        url = "https://mega.nz/file/NjIwwJoK#MVi3C3FAcSQPd7FRpQc0CoStBG8jSFuPn0jD-pG3zY0";
        outputHashAlgo = "sha256";
        outputHash = "VXBtEB3G5MTrWn9OOvmCG3sDoasjbKkLJruhdQZa4SQ=";
        outputHashMode = "recursive";
      }
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
  ];
  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
    autoPatchelfHook
  ];

  installPhase = ''
    runHook preInstall

    loeHome=$out/lib/${pname}
    mkdir -p $loeHome
    cp -r LoE/* $loeHome

    makeWrapper $loeHome/LoE.x86_64 $out/bin/LoE \
      --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeDeps}"

    icon=$out/share/icons/hicolor/128x128/apps/legends-of-equestria.png
    mkdir -p $(dirname $icon)
    ln -s $loeHome/LoE_Data/Resources/UnityPlayer.png $icon

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
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ ulysseszhan ];
    mainProgram = "LoE";
    homepage = "https://www.legendsofequestria.com";
    downloadPage = "https://www.legendsofequestria.com/downloads";
  };

}
