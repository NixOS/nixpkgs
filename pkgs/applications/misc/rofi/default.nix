{ stdenv, fetchurl, autoreconfHook, pkgconfig, libxkbcommon, pango, which, git
, cairo, glib, libxcb, xcbutil, xcbutilwm, xcbutilxrm, libstartup_notification
}:

stdenv.mkDerivation rec {
  version = "1.3.1";
  name = "rofi-${version}";

  src = fetchurl {
    url = "https://github.com/DaveDavenport/rofi/releases/download/${version}/${name}.tar.gz";
    sha256 = "09i3vd8k6zqphrm382fglsmxc4q6dg00xddzl96kakszgvdd4qfs";
  };

  preConfigure = ''
    patchShebangs "script"
    # root not present in build /etc/passwd
    sed -i 's/~root/~nobody/g' test/helper-expand.c
  '';

  buildInputs = [ autoreconfHook pkgconfig libxkbcommon pango cairo git
    libstartup_notification libxcb xcbutil xcbutilwm xcbutilxrm which
  ];
  doCheck = true;

  meta = with stdenv.lib; {
    description = "Window switcher, run dialog and dmenu replacement";
    homepage = https://davedavenport.github.io/rofi;
    license = licenses.mit;
    maintainers = with maintainers; [ mbakke garbas ];
    platforms = with platforms; unix;
  };
}
