{ stdenv, fetchurl, zlib, libX11, libXext, libSM, libICE
, libXfixes, libXt, libXi, libXcursor, libXScrnSaver, libXcomposite, libXdamage, libXtst, libXrandr
, alsaLib, dbus_libs, cups, libexif, ffmpeg, libudev
, freetype, fontconfig, libXft, libXrender, libxcb, expat, libXau, libXdmcp
, libuuid, xz
, gstreamer, gst_plugins_base, libxml2
, glib, gtk, pango, gdk_pixbuf, cairo, atk, gnome3
, nss, nspr
, patchelf
}:

let
  version = "1.1";
  build = "453.47-1";
  fullVersion = "stable_${version}.${build}";

  info = if stdenv.is64bit then {
      arch = "amd64";
      sha256 = "09kadsi4ydjciq092i6linapqzjdzx915zqmz7vfq6w1yp9mqbwq";
    } else {
      arch = "i386";
      sha256 = "0b5410phnkpg6sz0j345vdn0r6n89rm865bchqw8p4kx7pmy78z3";
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
      atk alsaLib dbus_libs cups gtk gdk_pixbuf libexif ffmpeg libudev
      freetype fontconfig libXrender libuuid expat glib nss nspr
      gstreamer libxml2 gst_plugins_base pango cairo gnome3.gconf
      patchelf
    ];

  libPath = stdenv.lib.makeLibraryPath buildInputs
    + stdenv.lib.optionalString (stdenv.is64bit)
      (":" + stdenv.lib.makeSearchPathOutputs "lib64" ["lib"] buildInputs);

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
