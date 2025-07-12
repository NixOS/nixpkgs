{
  stdenv,
  requireFile,
  autoPatchelfHook,
  makeWrapper,
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

  runtimeInputs = [
    libGL.out
    # leads to the following error if omitted:
    # Zygote could not fork: process_type gpu-process numfds 3 child_pid -1
    udev.out
  ];

  buildInputs = [
    alsa-lib.out
    at-spi2-atk.out
    cairo.out
    cups.lib
    dbus.lib
    expat.out
    gdk-pixbuf.out
    glib.out
    gtk3.out
    libdrm.out
    libgbm.out
    libxkbcommon.out
    nspr.out
    nss.out
    pango.out
    xorg.libX11.out
    xorg.libXcomposite.out
    xorg.libXdamage.out
    xorg.libXext.out
    xorg.libXfixes.out
    xorg.libXrandr.out
    xorg.libxcb.out
  ];

  dontBuild = true;
  dontConfigure = true;
  preferLocalBuild = true;

  installPhase = ''
    mkdir -p $out/opt/optolith
    cp -rf . $out/opt/optolith
  '';

  postFixup = ''
    makeWrapper $out/opt/optolith/Optolith $out/bin/optolith \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeInputs}:$out/opt/optolith \
  '';

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
