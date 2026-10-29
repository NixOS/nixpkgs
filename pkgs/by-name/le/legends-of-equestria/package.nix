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
  libxscrnsaver,
  libxrender,
  libxrandr,
  libxi,
  libxinerama,
  libxfixes,
  libxext,
  libxdmcp,
  libxcursor,
  libxau,
  libx11,
  libxcb,
  wayland,
}:

let
  pname = "legends-of-equestria";
  version = "2025.06.002";
  description = "Free-to-play MMORPG";

  srcOptions = {
    x86_64-linux = {
      url = "https://mega.nz/file/QmBXXDiC#XoG19N2_uBIHVKDNId5mE4cod9q29iPkYOfGDgAX_Oo";
      outputHash = "IdcowkU2k2grg133jTf3EOENATCCige64BMYXtFupRE=";
    };
    x86_64-darwin = {
      url = "https://mega.nz/file/Uy4WzbCL#5tCRmmrizaIdilo2iYLSVkoSSNDleyQ8ZNYYT5hJsR4";
      outputHash = "D/2G7w89Z4JTP0TEjnlBKI7XCBx2LBurXZcEp0gW+JA=";
    };
    aarch64-darwin = {
      url = "https://mega.nz/file/xr4AHIrb#pD5wDIiYys2my4_59UWiYoqBpdyUQHf_CalPZe7hpME";
      outputHash = "PpDUFnobznB5FHYSF+m9S3RcNIdi7eWyxxDHRdS+zlY=";
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
    libx11
    libxcb
    libxau
    libxdmcp
    libxext
    libxcursor
    libxrender
    libxfixes
    libxinerama
    libxi
    libxrandr
    libxscrnsaver
  ];
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
        cp -r * $loeHome

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
