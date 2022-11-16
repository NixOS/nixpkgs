{ lib
, stdenv
, fetchurl
, libGL
, zlib
, libxkbcommon
, glib
, makeWrapper
, xorg
, dbus
, fontconfig
, freetype
, makeDesktopItem
}:

stdenv.mkDerivation rec {
  pname = "ida-free";
  version = "8.1.0.221006";

  src =
    if stdenv.hostPlatform.system != "x86_64-linux" then throw "unsupported platform"
    else
      fetchurl {
        urls = [
          "https://out7.hex-rays.com/files/idafree81_linux.run"
          "https://web.archive.org/web/20221020093306if_/https://out7.hex-rays.com/files/idafree81_linux.run"
        ];
        sha256 = "E9CQ7kcIhNNlZ3Wwk1gmZBhrrueAT//R5un54W2bWeU=";
      };

  icon = fetchurl {
    urls = [
      "https://www.hex-rays.com/products/ida/news/8_1/images/icon_free.png"
      "https://web.archive.org/web/20221105181231if_/https://hex-rays.com/products/ida/news/8_1/images/icon_free.png"
    ];
    sha256 = "sha256-widkv2VGh+eOauUK/6Sz/e2auCNFAsc8n9z0fdrSnW0=";
  };

  desktopItem = makeDesktopItem {
    name = pname;
    exec = "ida64";
    icon = icon;
    comment = "Freeware version of the world's smartest and most feature-full disassembler";
    desktopName = "IDA Free";
    genericName = "Interactive Disassembler";
    categories = [ "Development" ];
  };

  ldLibraryPath = lib.makeLibraryPath [
    stdenv.cc.cc
    zlib
    glib
    xorg.libXi
    xorg.libxcb
    xorg.libXrender
    xorg.libXau
    xorg.libX11
    xorg.libSM
    xorg.libICE
    xorg.libXext
    xorg.xcbutilwm
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    libxkbcommon
    dbus
    fontconfig
    freetype
    libGL
  ];

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;
  dontStrip = true;
  dontPatchELF = true;

  installPhase = ''
    runHook preInstall

    IDADIR=$out/opt/${pname}

    install -d $IDADIR $out/bin $out/share/applications

    # Invoke the installer with the dynamic loader directly, avoiding the need
    # to copy it to fix permissions and patch the executable.
    $(cat $NIX_CC/nix-support/dynamic-linker) ${src} \
      --mode unattended --prefix $IDADIR --installpassword ""

    rm $IDADIR/[Uu]ninstall*

    for bb in ida64 assistant; do
      patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $IDADIR/$bb
    done

    wrapProgram \
      $IDADIR/ida64 \
      --set LD_LIBRARY_PATH "$IDADIR:${ldLibraryPath}" \
      --set QT_PLUGIN_PATH "$IDADIR/plugins/platforms"

    ln -s $IDADIR/ida64 $out/bin/ida64

    cp $desktopItem/share/applications/* $out/share/applications

    runHook postInstall
  '';

  meta = {
    description = "Freeware version of the world's smartest and most feature-full disassembler";
    homepage = "https://hex-rays.com/ida-free/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ athre0z ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "ida64";
  };
}
