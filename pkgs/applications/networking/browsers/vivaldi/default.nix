{ stdenv, fetchurl, zlib, libX11, libXext, libSM, libICE
, libXfixes, libXt, libXi, libXcursor, libXScrnSaver, libXcomposite, libXdamage, libXtst, libXrandr
, alsaLib, dbus_libs, cups, libexif, ffmpeg, libudev
, freetype, fontconfig, libXft, libXrender, libxcb, expat, libXau, libXdmcp
, libuuid, xz
, gst_all, libxml2
, glib, gtk, pango, gdk_pixbuf, cairo, atk, gnome3
, nss, nspr
, patchelf
}:

let
  version = "1.2";
  build = "490.39-1";
  fullVersion = "stable_${version}.${build}";

  info = if stdenv.is64bit then {
      arch = "amd64";
      sha256 = "188fb91f1eb41e1dcaeda982567260adb6c004f4df00de55eed962e6ca7c621e";
    } else {
      arch = "i386";
      sha256 = "0c699a0d7ced5e77c41a85e81077a1b4561d64071ec89e0e875a1c55e78634eb";
    };
in stdenv.mkDerivation rec {
  product    = "vivaldi";
  name       = "${product}-${version}";

  src = fetchurl {
    inherit (info) sha256;
    url = "https://downloads.vivaldi.com/stable/${product}-${fullVersion}_${info.arch}.deb";
  };

  unpackPhase = ''
    ar vx ${src}
    tar -xvf data.tar.xz
  '';

  buildInputs = with gst_all;
    [ stdenv.cc.cc stdenv.cc.libc zlib libX11 libXt libXext libSM libICE
      libXi libXft libXcursor libXfixes libXScrnSaver libXcomposite libXdamage libXtst libXrandr
      atk alsaLib dbus_libs cups gtk gdk_pixbuf libexif ffmpeg libudev
      freetype fontconfig libXrender libuuid expat glib nss nspr
      gstreamer libxml2 gst-plugins-base pango cairo gnome3.gconf
      patchelf
    ];

  libPath = stdenv.lib.makeLibraryPath buildInputs
    + stdenv.lib.optionalString (stdenv.is64bit)
      (":" + stdenv.lib.makeSearchPathOutput "lib" "lib64" buildInputs);

  buildPhase = ''
    echo "Patching Vivaldi binaries"
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
    opt/vivaldi/vivaldi-bin
    echo "Finished patching Vivaldi binaries"
  '';

  dontPatchELF = true;
  dontStrip    = true;

  installPhase = ''
    mkdir -p "$out"
    cp -r opt "$out"
    mkdir "$out/bin"
    ln -s "$out/opt/vivaldi/vivaldi" "$out/bin/vivaldi"
  '';

  meta = with stdenv.lib; {
    description = "A Browser for our Friends, powerful and personal";
    homepage    = "https://vivaldi.com";
    license     = licenses.unfree;
    maintainers = with maintainers; [ otwieracz nequissimus ];
    platforms   = platforms.linux;
  };
}
