{ stdenv, fetchurl, zlib, libX11, libXext, libSM, libICE
, libXfixes, libXt, libXi, libXcursor, libXScrnSaver, libXcomposite, libXdamage, libXtst, libXrandr
, alsaLib, dbus_libs, cups, libexif, ffmpeg, udev
, freetype, fontconfig, libXft, libXrender, libxcb, expat, libXau, libXdmcp
, libuuid, xz
, gstreamer, gst_plugins_base, libxml2
, glib, gtk, pango, gdk_pixbuf, cairo, atk, gnome3
, nss, nspr
, patchelf
}:

let
  archUrl = name: arch: "https://vivaldi.com/download/stable/${name}_${arch}.deb";
in
stdenv.mkDerivation rec {
  version    = "1.0";
  debversion = "stable_1.0.435.40-1";
  product    = "vivaldi";
  name       = "${product}-${version}";

  src = if stdenv.system == "x86_64-linux"
    then fetchurl {
      url    = archUrl "vivaldi-${debversion}" "amd64";
      sha256 = "12c051a40258a95f9594eed2f73fa5f591482ac2a41d5cf643811b1ea2a1efbf";
    }
    else if stdenv.system == "i686-linux"
    then fetchurl {
      url    = archUrl "vivaldi-${debversion}" "i386";
      sha256 = "6e0b84fba38211bab9a71bc10e97398fca77c0acd82791923c1d432b20846f0f";
    }
    else throw "Vivaldi is not supported on ${stdenv.system} (only i686-linux and x86_64 linux are supported)";

  unpackPhase = ''
    ar vx ${src}
    tar -xvf data.tar.xz
  '';

  buildInputs =
    [ stdenv.cc.cc stdenv.cc.libc zlib libX11 libXt libXext libSM libICE
      libXi libXft libXcursor libXfixes libXScrnSaver libXcomposite libXdamage libXtst libXrandr
      atk alsaLib dbus_libs cups gtk gdk_pixbuf libexif ffmpeg udev
      freetype fontconfig libXrender libuuid expat glib nss nspr
      gstreamer libxml2 gst_plugins_base pango cairo gnome3.gconf 
      patchelf
    ];

  libPath = stdenv.lib.makeLibraryPath buildInputs
    + stdenv.lib.optionalString (stdenv.system == "x86_64-linux")
      (":" + stdenv.lib.makeSearchPath "lib64" buildInputs);

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
    maintainers = with maintainers; [ otwieracz ];
    platforms   = platforms.linux;
  };
}
