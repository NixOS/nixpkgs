{ stdenv, fetchurl, zlib, libX11, libXext, libSM, libICE
, libXfixes, libXt, libXi, libXcursor, libXScrnSaver, libXcomposite, libXdamage, libXtst, libXrandr
, alsaLib, dbus_libs, cups, libexif, ffmpeg, systemd
, freetype, fontconfig, libXft, libXrender, libxcb, expat, libXau, libXdmcp
, libuuid, xz
, gstreamer, gst-plugins-base, libxml2
, glib, gtk3, pango, gdk_pixbuf, cairo, atk, gnome3
, nss, nspr
, patchelf, makeWrapper
, proprietaryCodecs ? false, vivaldi-ffmpeg-codecs ? null
}:

stdenv.mkDerivation rec {
  name = "${product}-${version}";
  product = "vivaldi";
  version = "1.13.1008.34-1";
 
  src = fetchurl {
    url = "https://downloads.vivaldi.com/stable/${product}-stable_${version}_amd64.deb";
    sha256 = "18p5n87n5rkd6dhdsf2lvcyhg6ipn0k4p6a79dy93vsgjmk4bvw2";
   };

  unpackPhase = ''
    ar vx ${src}
    tar -xvf data.tar.xz
  '';

  nativeBuildInputs = [ patchelf makeWrapper ];

  buildInputs = [
    stdenv.cc.cc stdenv.cc.libc zlib libX11 libXt libXext libSM libICE libxcb
    libXi libXft libXcursor libXfixes libXScrnSaver libXcomposite libXdamage libXtst libXrandr
    atk alsaLib dbus_libs cups gtk3 gdk_pixbuf libexif ffmpeg systemd
    freetype fontconfig libXrender libuuid expat glib nss nspr
    gstreamer libxml2 gst-plugins-base pango cairo gnome3.gconf
  ] ++ stdenv.lib.optional proprietaryCodecs vivaldi-ffmpeg-codecs;

  libPath = stdenv.lib.makeLibraryPath buildInputs
    + stdenv.lib.optionalString (stdenv.is64bit)
      (":" + stdenv.lib.makeSearchPathOutput "lib" "lib64" buildInputs)
    + ":$out/opt/vivaldi/lib";

  buildPhase = ''
    echo "Patching Vivaldi binaries"
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      opt/vivaldi/vivaldi-bin
  '' + stdenv.lib.optionalString proprietaryCodecs ''
    sed -i '/^VIVALDI_FFMPEG_FOUND/ a \
    checkffmpeg "${vivaldi-ffmpeg-codecs}/lib/libffmpeg.so"' opt/vivaldi/vivaldi
  '' + ''
    echo "Finished patching Vivaldi binaries"
  '';

  dontPatchELF = true;
  dontStrip    = true;

  installPhase = ''
    mkdir -p "$out"
    cp -r opt "$out"
    mkdir "$out/bin"
    ln -s "$out/opt/vivaldi/vivaldi" "$out/bin/vivaldi"
    mkdir -p "$out/share"
    cp -r usr/share/{applications,xfce4} "$out"/share
    substituteInPlace "$out"/share/applications/*.desktop \
      --replace /usr/bin/vivaldi-stable "$out"/bin/vivaldi
    local d
    for d in 16 22 24 32 48 64 128 256; do
      mkdir -p "$out"/share/icons/hicolor/''${d}x''${d}/apps
      ln -s \
        "$out"/opt/vivaldi/product_logo_''${d}.png \
        "$out"/share/icons/hicolor/''${d}x''${d}/apps/vivaldi.png
    done
    wrapProgram "$out/bin/vivaldi" \
      --suffix XDG_DATA_DIRS : ${gtk3}/share/gsettings-schemas/${gtk3.name}/
  '';

  meta = with stdenv.lib; {
    description = "A Browser for our Friends, powerful and personal";
    homepage    = "https://vivaldi.com";
    license     = licenses.unfree;
    maintainers = with maintainers; [ otwieracz nequissimus ];
    platforms   = [ "x86_64-linux" ];
  };
}
