{ stdenv, fetchurl, pkgconfig
, libxml2, libXinerama, libXcursor, libXau, libXrandr
, imlib2, pango, libstartup_notification, makeWrapper}:

stdenv.mkDerivation rec {
  name = "openbox-3.5.2";

  buildInputs = [
    pkgconfig libxml2
    libXinerama libXcursor libXau libXrandr
    imlib2 pango libstartup_notification
    makeWrapper
  ];

  src = fetchurl {
    url = "http://openbox.org/dist/openbox/${name}.tar.gz";
    sha256 = "0cxgb334zj6aszwiki9g10i56sm18i7w1kw52vdnwgzq27pv93qj";
  };

  # Openbox needs XDG_DATA_DIRS set or it can't find its default theme
  postInstall = ''
    wrapProgram "$out/bin/openbox" --prefix XDG_DATA_DIRS : "$out/share"
    wrapProgram "$out/bin/openbox-session" --prefix XDG_DATA_DIRS : "$out/share"
    wrapProgram "$out/bin/openbox-gnome-session" --prefix XDG_DATA_DIRS : "$out/share"
    wrapProgram "$out/bin/openbox-kde-session" --prefix XDG_DATA_DIRS : "$out/share"
    '';

  meta = {
    description = "X window manager for non-desktop embedded systems";
    homepage = http://openbox.org/;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
