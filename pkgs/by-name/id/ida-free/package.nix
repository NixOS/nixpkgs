{ autoPatchelfHook
, cairo
, copyDesktopItems
, dbus
, fetchurl
, fontconfig
, freetype
, glib
, gtk3
, lib
, libdrm
, libGL
, libkrb5
, libsecret
, libsForQt5
, libunwind
, libxkbcommon
, makeDesktopItem
, makeWrapper
, openssl
, stdenv
, xorg
, zlib
}:

let
  srcs = builtins.fromJSON (builtins.readFile ./srcs.json);
in
stdenv.mkDerivation rec {
  pname = "ida-free";
  version = "8.4.240320";

  src = fetchurl {
    inherit (srcs.${stdenv.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}")) urls sha256;
  };

  icon = fetchurl {
    urls = [
      "https://www.hex-rays.com/products/ida/news/8_1/images/icon_free.png"
      "https://web.archive.org/web/20221105181231if_/https://hex-rays.com/products/ida/news/8_1/images/icon_free.png"
    ];
    sha256 = "sha256-widkv2VGh+eOauUK/6Sz/e2auCNFAsc8n9z0fdrSnW0=";
  };

  desktopItem = makeDesktopItem {
    name = "ida-free";
    exec = "ida64";
    icon = icon;
    comment = meta.description;
    desktopName = "IDA Free";
    genericName = "Interactive Disassembler";
    categories = [ "Development" ];
    startupWMClass = "IDA";
  };

  desktopItems = [ desktopItem ];

  nativeBuildInputs = [ makeWrapper copyDesktopItems autoPatchelfHook libsForQt5.wrapQtAppsHook ];

  # We just get a runfile in $src, so no need to unpack it.
  dontUnpack = true;

  # Add everything to the RPATH, in case IDA decides to dlopen things.
  runtimeDependencies = [
    cairo
    dbus
    fontconfig
    freetype
    glib
    gtk3
    libdrm
    libGL
    libkrb5
    libsecret
    libsForQt5.qtbase
    libunwind
    libxkbcommon
    openssl
    stdenv.cc.cc
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libXau
    xorg.libxcb
    xorg.libXext
    xorg.libXi
    xorg.libXrender
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.xcbutilwm
    zlib
  ];
  buildInputs = runtimeDependencies;

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $out/opt

    # IDA depends on quite some things extracted by the runfile, so first extract everything
    # into $out/opt, then remove the unnecessary files and directories.
    IDADIR=$out/opt

    # Invoke the installer with the dynamic loader directly, avoiding the need
    # to copy it to fix permissions and patch the executable.
    $(cat $NIX_CC/nix-support/dynamic-linker) $src \
      --mode unattended --prefix $IDADIR --installpassword ""

    # Copy the exported libraries to the output.
    cp $IDADIR/libida64.so $out/lib

    # Some libraries come with the installer.
    addAutoPatchelfSearchPath $IDADIR

    for bb in ida64 assistant; do
      wrapProgram $IDADIR/$bb \
        --prefix QT_PLUGIN_PATH : $IDADIR/plugins/platforms
      ln -s $IDADIR/$bb $out/bin/$bb
    done

    # runtimeDependencies don't get added to non-executables, and openssl is needed
    #  for cloud decompilation
    patchelf --add-needed libcrypto.so $IDADIR/libida64.so

    runHook postInstall
  '';

  meta = with lib; {
    description = "Freeware version of the world's smartest and most feature-full disassembler";
    homepage = "https://hex-rays.com/ida-free/";
    changelog = "https://hex-rays.com/products/ida/news/";
    license = licenses.unfree;
    mainProgram = "ida64";
    maintainers = with maintainers; [ msanft ];
    platforms = [ "x86_64-linux" ]; # Right now, the installation script only supports Linux.
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
