{ stdenv, fetchurl, autoreconfHook, pkgconfig, libxkbcommon, pango, which, git
, cairo, libxcb, xcbutil, xcbutilwm, xcbutilxrm, libstartup_notification
, bison, flex, librsvg, check
}:

stdenv.mkDerivation rec {
  version = "1.5.3";
  name = "rofi-unwrapped-${version}";

  src = fetchurl {
    url = "https://github.com/DaveDavenport/rofi/releases/download/${version}/rofi-${version}.tar.gz";
    sha256 = "1mskknfnpgmaghplwcyc44qc8swb1f9qiyi67fz9i77jijjpj1lx";
  };

  preConfigure = ''
    patchShebangs "script"
    # root not present in build /etc/passwd
    sed -i 's/~root/~nobody/g' test/helper-expand.c
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libxkbcommon pango cairo git bison flex librsvg check
    libstartup_notification libxcb xcbutil xcbutilwm xcbutilxrm which
  ];
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Window switcher, run dialog and dmenu replacement";
    homepage = https://github.com/davatorium/rofi;
    license = licenses.mit;
    maintainers = with maintainers; [ mbakke ma27 ];
    platforms = with platforms; linux;
  };
}
