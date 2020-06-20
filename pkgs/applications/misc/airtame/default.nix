{ stdenv, lib, fetchurl, makeDesktopItem, makeWrapper
, alsaLib, atk, cairo, cups, curl, dbus, expat, ffmpeg_3, fontconfig, freetype
, gdk-pixbuf, glib, glibc, gnome2, gtk2, libX11, libXScrnSaver, libXcomposite
, libXcursor, libXdamage, libXext, libXfixes, libXi, libXrandr, libXrender
, libXtst, libopus, libpulseaudio, libxcb, nspr, nss, pango, udev, x264
}:

let libPath = lib.makeLibraryPath [
  alsaLib atk cairo cups curl dbus expat ffmpeg_3 fontconfig freetype gdk-pixbuf
  glib glibc gnome2.GConf gtk2 libopus nspr nss pango stdenv.cc.cc udev x264
  libX11 libXScrnSaver libXcomposite libXcursor libXdamage libXext libXfixes
  libXi libXrandr libXrender libXtst libpulseaudio libxcb
];
in stdenv.mkDerivation rec {
  pname = "airtame";
  version = "3.3.0";
  longName = "${pname}-application";

  src = fetchurl {
    url = "https://downloads.airtame.com/application/ga/lin_x64/releases/${longName}-${version}.tar.gz";
    sha256 = "16ca1vcxpka26jcrfbxpq74kcizgrm138j94bby6kzqp2swhrl76";
  };

  nativeBuildInputs = [ makeWrapper ];

  desktopItem = makeDesktopItem rec {
    name = "airtame";
    exec = longName;
    comment = "Airtame Streaming Client";
    desktopName = "Airtame";
    icon = name;
    genericName = comment;
    categories = "Application;Network;";
  };

  installPhase = ''
    opt="$out/opt/airtame"
    mkdir -p "$opt"
    cp -R . "$opt"
    mkdir -p "$out/bin"
    ln -s "$opt/${longName}" "$out/bin/"
    mkdir -p "$out/share"
    cp -r "${desktopItem}/share/applications" "$out/share/"
    mkdir -p "$out/share/icons"
    ln -s "$opt/icon.png" "$out/share/icons/airtame.png"

    # Flags and rpath are copied from launch-airtame.sh.
    vendorlib="\
    $opt/resources/app.asar.unpacked/modules/streamer/dist/deps/airtame-modules:\
    $opt/resources/app.asar.unpacked/encryption/out/lib:\
    $opt/resources/deps/airtame-core/lib:\
    $opt/resources/deps/airtame-encryption/lib"

    echo $vendorlib

    rpath="${libPath}:$opt:$vendorlib"

    find "$opt" \( -type f -executable -o -name "*.so" -o -name "*.so.*" \) \
      -exec patchelf --set-rpath "$rpath" {} \;

    # The main binary also needs libudev which was removed by --shrink-rpath.
    interp="$(< $NIX_CC/nix-support/dynamic-linker)"
    patchelf --set-interpreter "$interp" $opt/${longName}

    wrapProgram $opt/${longName} \
      --prefix LD_LIBRARY_PATH=$rpath \
      --add-flags "--disable-gpu --enable-transparent-visuals"
  '';

  dontPatchELF = true;

  meta = with stdenv.lib; {
    homepage = "https://airtame.com/download";
    description = "Wireless streaming client for Airtame devices";
    license = licenses.unfree;
    maintainers = with maintainers; [ thanegill ];
    platforms = platforms.linux;
  };
}
