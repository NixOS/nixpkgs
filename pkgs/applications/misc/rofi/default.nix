{ stdenv, lib, fetchurl
, autoreconfHook, pkg-config, libxkbcommon, pango, which, git
, cairo, libxcb, xcbutil, xcbutilwm, xcbutilxrm, libstartup_notification
, bison, flex, librsvg, check
}:

stdenv.mkDerivation rec {
  pname = "rofi-unwrapped";
  version = "1.6.1";

  src = fetchurl {
    url = "https://github.com/davatorium/rofi/releases/download/${version}/rofi-${version}.tar.gz";
    sha256 = "04glljqbf9ckkc6x6fv4x1gqmy468n1agya0kd8rxdvz24wzf7cd";
  };

  preConfigure = ''
    patchShebangs "script"
    # root not present in build /etc/passwd
    sed -i 's/~root/~nobody/g' test/helper-expand.c
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libxkbcommon pango cairo git bison flex librsvg check
    libstartup_notification libxcb xcbutil xcbutilwm xcbutilxrm which
  ];

  doCheck = false;

  meta = with lib; {
    description = "Window switcher, run dialog and dmenu replacement";
    homepage = "https://github.com/davatorium/rofi";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = with platforms; linux;
  };
}
