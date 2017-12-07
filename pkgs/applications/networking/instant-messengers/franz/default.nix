{ stdenv, fetchurl, makeDesktopItem
, xorg, gtk2, atk, glib, pango, gdk_pixbuf, cairo, freetype, fontconfig
, gnome2, dbus, nss, nspr, alsaLib, cups, expat, udev, libnotify }:

let
  bits = if stdenv.system == "x86_64-linux" then "x64"
         else "ia32";

  version = "4.0.4";

  runtimeDeps = [
    udev libnotify
  ];
  deps = (with xorg; [
    libXi libXcursor libXdamage libXrandr libXcomposite libXext libXfixes
    libXrender libX11 libXtst libXScrnSaver
  ]) ++ [
    gtk2 atk glib pango gdk_pixbuf cairo freetype fontconfig dbus
    gnome2.GConf nss nspr alsaLib cups expat stdenv.cc.cc
  ] ++ runtimeDeps;

  desktopItem = makeDesktopItem rec {
    name = "Franz";
    exec = name;
    icon = "franz";
    desktopName = name;
    genericName = "Franz messenger";
    categories = "Network;";
  };
in stdenv.mkDerivation rec {
  name = "franz-${version}";
  src = fetchurl {
    url = "https://github.com/meetfranz/franz-app/releases/download/${version}/Franz-linux-${bits}-${version}.tgz";
    sha256 = if bits == "x64" then
      "0ssym0jfrig474g6j67g1jfybjkxnyhbqqjvrs8z6ihwlyd3rrk5" else
      "16l9jma2hiwzl9l41yhrwribcgmxca271rq0cfbbm9701mmmciyy";
  };

  # don't remove runtime deps
  dontPatchELF = true;

  unpackPhase = ''
    tar xzf $src
  '';

  installPhase = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" Franz
    patchelf --set-rpath "$out/opt/franz:${stdenv.lib.makeLibraryPath deps}" Franz

    mkdir -p $out/bin $out/opt/franz
    cp -r * $out/opt/franz
    ln -s $out/opt/franz/Franz $out/bin

    # provide desktop item and icon
    mkdir -p $out/share/applications $out/share/pixmaps
    ln -s ${desktopItem}/share/applications/* $out/share/applications
    ln -s $out/opt/franz/resources/app.asar.unpacked/assets/franz.png $out/share/pixmaps
  '';

  postFixup = ''
    paxmark m $out/opt/franz/Franz
  '';

  meta = with stdenv.lib; {
    description = "A free messaging app that combines chat & messaging services into one application";
    homepage = http://meetfranz.com;
    license = licenses.free;
    maintainers = [ maintainers.gnidorah ];
    platforms = ["i686-linux" "x86_64-linux"];
    hydraPlatforms = [];
  };
}
