{ stdenv, fetchurl, pkgconfig
, libxml2, libXinerama, libXcursor, libXau, libXrandr
, imlib2, pango, libstartup_notification, makeWrapper }:

stdenv.mkDerivation rec {
  name = "openbox-${version}";
  version = "3.6.1";

  buildInputs = [
    pkgconfig libxml2
    libXinerama libXcursor libXau libXrandr
    libstartup_notification makeWrapper
  ];

  propagatedBuildInputs = [
    pango imlib2
  ];

  src = fetchurl {
    url = "http://openbox.org/dist/openbox/${name}.tar.gz";
    sha256 = "1xvyvqxlhy08n61rjkckmrzah2si1i7nmc7s8h07riqq01vc0jlb";
  };

  setlayoutSrc = fetchurl {
    url = "http://openbox.org/dist/tools/setlayout.c";
    sha256 = "1ci9lq4qqhl31yz1jwwjiawah0f7x0vx44ap8baw7r6rdi00pyiv";
  };

  postBuild = "gcc -O2 -o setlayout $(pkg-config --cflags --libs x11) $setlayoutSrc";

  # Openbox needs XDG_DATA_DIRS set or it can't find its default theme
  postInstall = ''
    cp -a setlayout "$out"/bin
    wrapProgram "$out/bin/openbox" --prefix XDG_DATA_DIRS : "$out/share"
    wrapProgram "$out/bin/openbox-session" --prefix XDG_DATA_DIRS : "$out/share"
    wrapProgram "$out/bin/openbox-gnome-session" --prefix XDG_DATA_DIRS : "$out/share"
    wrapProgram "$out/bin/openbox-kde-session" --prefix XDG_DATA_DIRS : "$out/share"
    '';

  meta = {
    description = "X window manager for non-desktop embedded systems";
    homepage = http://openbox.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
