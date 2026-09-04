{
  stdenv,
  fetchurl,
  requireFile,
  autoPatchelfHook,
  makeWrapper,
  makeDesktopItem,
  lib,

  libGL,
  udev,
  alsa-lib,
  at-spi2-atk,
  cairo,
  cups,
  dbus,
  expat,
  gdk-pixbuf,
  glib,
  gtk3,
  libdrm,
  libgbm,
  libxkbcommon,
  nspr,
  nss,
  pango,
  xorg,
}:

stdenv.mkDerivation rec {
  name = "optolith";
  version = "1.5.2";

  src = requireFile rec {
    name = "989002-Optolith_1.5.2.tar.gz";
    hash = "sha256-CoGEsPxi8nZFJYdH51AgQVSrIFtlL6J6HYo8Lzp59Fg=";

    message = ''
      In order to install Optolith, you need to comply with the license agreement and download
      the binaries, ${name}, from:

      ${meta.downloadPage}

      Once you have downloaded the file, please use the following command and re-run the
      installation:

      nix-prefetch-url file://\$PWD/${name}
    '';
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    cairo
    cups.lib
    dbus.lib
    expat
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libgbm
    libxkbcommon
    nspr
    nss
    pango
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
  ];

  dontBuild = true;
  dontConfigure = true;
  preferLocalBuild = true;

  installPhase =
    let
      desktopicon = fetchurl {
        name = "optolith.png";
        url = "https://raw.githubusercontent.com/elyukai/optolith-client/refs/tags/v${version}/app/icon.png";
        hash = "sha256-E18paIyCzdlEuU7ykolahb0pCq7JGD9/OpBWoUyazoA=";
      };
    in
    ''
      mkdir -p $out/opt/optolith
      cp -r . $out/opt/optolith
      install -Dm644 ${desktopicon} $out/share/pixmaps/optolith.png
    '';

  postFixup =
    let
      runtimeInputs = [
        libGL
        # leads to the following error if omitted:
        # Zygote could not fork: process_type gpu-process numfds 3 child_pid -1
        udev
      ];
    in
    ''
      makeWrapper $out/opt/optolith/Optolith $out/bin/optolith \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeInputs}:$out/opt/optolith \
    '';

  desktopItems = [
    (makeDesktopItem {
      name = "optolith";
      icon = "optolith";
      desktopName = "Optolith";
      exec = meta.mainProgram;
      comment = meta.description;
      terminal = false;
      categories = [ "Game" ];
    })
  ];

  meta = {
    description = "Character generator for The Dark Eye 5th Edition";
    homepage = "https://github.com/elyukai/optolith-client";
    downloadPage = "https://www.ulisses-ebooks.de/product/220253";
    mainProgram = "optolith";
    # the program itself is MPLv2, but the bundled content yaml files are proprietary
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ valodim ];
  };
}
