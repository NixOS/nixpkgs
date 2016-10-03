{ stdenv, fetchurl
, xorg, gtk2, atk, glib, pango, gdk_pixbuf, cairo, freetype, fontconfig
, gnome2, dbus, nss, nspr, alsaLib, cups, expat, udev, libnotify }:

stdenv.mkDerivation rec {
  version = "4.0.4";
  name = "franz-${version}";
  src = fetchurl {
    url = "https://github.com/meetfranz/franz-app/releases/download/4.0.4/Franz-linux-x64-${version}.tgz";
    sha256 = "0ssym0jfrig474g6j67g1jfybjkxnyhbqqjvrs8z6ihwlyd3rrk5";
  };

  phases = [ "unpackPhase" "installPhase" ];

  deps = with xorg; [
   gtk2 atk glib pango gdk_pixbuf cairo freetype fontconfig dbus
   libXi libXcursor libXdamage libXrandr libXcomposite libXext libXfixes
   libXrender libX11 libXtst libXScrnSaver gnome2.GConf nss nspr alsaLib
   cups expat stdenv.cc.cc

   udev libnotify
  ];

  unpackPhase = ''
    tar xzf $src
  '';

  installPhase = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" Franz
    patchelf --set-rpath "$out/share/franz:${stdenv.lib.makeLibraryPath deps}" Franz

    mkdir -p $out/bin $out/share/franz
    cp -r * $out/share/franz
    ln -s $out/share/franz/Franz $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A free messaging app that combines chat & messaging services into one application";
    homepage = http://meetfranz.com;
    license = licenses.free;
    maintainers = [ stdenv.lib.maintainers.gnidorah ];
    platforms = ["x86_64-linux"];
    hydraPlatforms = [];
  };
}
