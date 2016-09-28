{ stdenv, fetchurl, autoreconfHook, pkgconfig, libxkbcommon, pango
, cairo, glib, libxcb, xcbutil, xcbutilwm, xcbutilxrm, libstartup_notification
}:

stdenv.mkDerivation rec {
  version = "1.2.0";
  name = "rofi-${version}";

  src = fetchurl {
    url = "https://github.com/DaveDavenport/rofi/releases/download/${version}/${name}.tar.xz";
    sha256 = "0xxx0xpxhrhlhi2axq9867zqrhwqavc1qrr833k1xr0pvm5m0aqc";
  };

  preConfigure = ''
    patchShebangs "script"
    # root not present in build /etc/passwd
    sed -i 's/~root/~nobody/g' test/helper-expand.c
  '';

  buildInputs = [ autoreconfHook pkgconfig libxkbcommon pango cairo
    libstartup_notification libxcb xcbutil xcbutilwm xcbutilxrm
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
