{ stdenv, fetchurl, autoreconfHook, pkgconfig, libxkbcommon, pango, which, git
, cairo, glib, libxcb, xcbutil, xcbutilwm, xcbutilxrm, libstartup_notification
}:

stdenv.mkDerivation rec {
  version = "1.3.0";
  name = "rofi-${version}";

  src = fetchurl {
    url = "https://github.com/DaveDavenport/rofi/releases/download/${version}/${name}.tar.xz";
    sha256 = "1a65ai93ygras5bi7wc0s5i3zqslzqlnw3klq3sdnp2p0d6hjjqn";
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
