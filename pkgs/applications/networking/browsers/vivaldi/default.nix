{ stdenv, fetchurl, zlib, libX11, libXext, libSM, libICE
, libXfixes, libXt, libXi, libXcursor, libXScrnSaver, libXcomposite, libXdamage, libXtst, libXrandr
, alsaLib, dbus_libs, cups, libexif, ffmpeg, systemd
, freetype, fontconfig, libXft, libXrender, libxcb, expat, libXau, libXdmcp
, libuuid, xz
, gstreamer, gst_plugins_base, libxml2
, glib, gtk, pango, gdk_pixbuf, cairo, atk, gnome3
, nss, nspr
, patchelf
}:

let
  version = "1.3";
  build = "551.30-1";
  fullVersion = "stable_${version}.${build}";

  info = if stdenv.is64bit then {
      arch = "amd64";
      sha256 = "89d0630c9df56cfb12a87f23430179f6d14a8c57fb029d1c8d28ab06c98b7640";
    } else {
      arch = "i386";
      sha256 = "0a7e07833f5359e38516222767da63edeca92177cbb6d4ef4946a6ef7c7b2946";
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

  buildInputs =
    [ stdenv.cc.cc stdenv.cc.libc zlib libX11 libXt libXext libSM libICE
      libXi libXft libXcursor libXfixes libXScrnSaver libXcomposite libXdamage libXtst libXrandr
      atk alsaLib dbus_libs cups gtk gdk_pixbuf libexif ffmpeg systemd
      freetype fontconfig libXrender libuuid expat glib nss nspr
      gstreamer libxml2 gst_plugins_base pango cairo gnome3.gconf
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
