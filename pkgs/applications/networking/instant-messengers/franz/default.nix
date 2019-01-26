{ stdenv, fetchurl, makeWrapper, autoPatchelfHook, dpkg
, xorg, atk, glib, pango, gdk_pixbuf, cairo, freetype, fontconfig, gtk3
, gnome2, dbus, nss, nspr, alsaLib, cups, expat, udev, libnotify, xdg_utils }:

let
  version = "5.0.0-beta.19";
in stdenv.mkDerivation rec {
  name = "franz-${version}";
  src = fetchurl {
    url = "https://github.com/meetfranz/franz/releases/download/v${version}/franz_${version}_amd64.deb";
    sha256 = "1b9b8y19iqx8bnax7hbh9rkjfxk8a9gqb1akrcxwwfi46l816gyy";
  };

  # don't remove runtime deps
  dontPatchELF = true;

  nativeBuildInputs = [ autoPatchelfHook makeWrapper dpkg ];
  buildInputs = (with xorg; [
    libXi libXcursor libXdamage libXrandr libXcomposite libXext libXfixes
    libXrender libX11 libXtst libXScrnSaver
  ]) ++ [
    gtk3 atk glib pango gdk_pixbuf cairo freetype fontconfig dbus
    gnome2.GConf nss nspr alsaLib cups expat stdenv.cc.cc
  ];
  runtimeDependencies = [ udev.lib libnotify ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p $out/bin
    cp -r opt $out
    ln -s $out/opt/Franz/franz $out/bin

    # provide desktop item and icon
    cp -r usr/share $out
    substituteInPlace $out/share/applications/franz.desktop \
      --replace Exec=\"/opt/Franz/franz\" Exec=franz
  '';

  postFixup = ''
    wrapProgram $out/opt/Franz/franz --prefix PATH : ${xdg_utils}/bin
  '';

  meta = with stdenv.lib; {
    description = "A free messaging app that combines chat & messaging services into one application";
    homepage = https://meetfranz.com;
    license = licenses.free;
    maintainers = [ maintainers.gnidorah ];
    platforms = ["x86_64-linux"];
    hydraPlatforms = [];
  };
}
