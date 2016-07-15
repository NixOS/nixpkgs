{ stdenv, fetchurl, autoreconfHook, pkgconfig, libX11, libxkbcommon, pango
, cairo, glib, libxcb, xcbutil, xcbutilwm, libstartup_notification
, i3Support ? false, i3
}:

stdenv.mkDerivation rec {
  version = "1.1.0";
  name = "rofi-${version}";

  src = fetchurl {
    url = "https://github.com/DaveDavenport/rofi/releases/download/${version}/${name}.tar.xz";
    sha256 = "1l8vl0mh7i0b1ycifqpg6392f5i4qxlv003m126skfk6fnlfq8hn";
  };

  preConfigure = ''
    patchShebangs "script"
    # root not present in build /etc/passwd
    sed -i 's/~root/~nobody/g' test/helper-expand.c
  '';

  buildInputs = [ autoreconfHook pkgconfig libX11 libxkbcommon pango
    cairo libstartup_notification libxcb xcbutil xcbutilwm
  ] ++ stdenv.lib.optional i3Support i3;

  meta = with stdenv.lib; {
    description = "Window switcher, run dialog and dmenu replacement";
    homepage = https://davedavenport.github.io/rofi;
    license = licenses.mit;
    maintainers = with maintainers; [ mbakke garbas ];
  };
}
