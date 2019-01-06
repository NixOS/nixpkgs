{ stdenv, fetchurl, makeDesktopItem, makeWrapper, autoPatchelfHook
, xorg, atk, glib, pango, gdk_pixbuf, cairo, freetype, fontconfig, gtk2
, gnome2, dbus, nss, nspr, alsaLib, cups, expat, udev, libnotify, xdg_utils }:

let
  bits = if stdenv.hostPlatform.system == "x86_64-linux" then "x64"
         else "ia32";

  version = "4.0.4";

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

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  buildInputs = (with xorg; [
    libXi libXcursor libXdamage libXrandr libXcomposite libXext libXfixes
    libXrender libX11 libXtst libXScrnSaver
  ]) ++ [
    gtk2 atk glib pango gdk_pixbuf cairo freetype fontconfig dbus
    gnome2.GConf nss nspr alsaLib cups expat stdenv.cc.cc
  ];
  runtimeDependencies = [ udev.lib libnotify ];

  unpackPhase = ''
    tar xzf $src
  '';

  installPhase = ''
    mkdir -p $out/bin $out/opt/franz
    cp -r * $out/opt/franz
    ln -s $out/opt/franz/Franz $out/bin

    # provide desktop item and icon
    mkdir -p $out/share/applications $out/share/pixmaps
    ln -s ${desktopItem}/share/applications/* $out/share/applications
    ln -s $out/opt/franz/resources/app.asar.unpacked/assets/franz.png $out/share/pixmaps
  '';

  postFixup = ''
    wrapProgram $out/opt/franz/Franz --prefix PATH : ${xdg_utils}/bin
  '';

  meta = with stdenv.lib; {
    description = "A free messaging app that combines chat & messaging services into one application";
    homepage = https://meetfranz.com;
    license = licenses.free;
    maintainers = [ maintainers.gnidorah ];
    platforms = ["i686-linux" "x86_64-linux"];
    hydraPlatforms = [];
  };
}
