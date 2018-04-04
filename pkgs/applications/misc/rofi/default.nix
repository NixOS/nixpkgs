{ stdenv, fetchurl, autoreconfHook, pkgconfig, libxkbcommon, pango, which, git
, cairo, glib, libxcb, xcbutil, xcbutilwm, xcbutilxrm, libstartup_notification
, bison, flex, librsvg, check
}:

stdenv.mkDerivation rec {
  version = "1.5.0";
  name = "rofi-${version}";

  src = fetchurl {
    url = "https://github.com/DaveDavenport/rofi/releases/download/${version}/${name}.tar.gz";
    sha256 = "0h068wqf0n6gmil2g3lh263pm7spkp4k5rxbnfp52n8izqgyf7al";
  };

  # config.patch may be removed in the future - https://github.com/DaveDavenport/rofi/pull/781
  patches = [ ./config.patch ];

  preConfigure = ''
    patchShebangs "script"
    # root not present in build /etc/passwd
    sed -i 's/~root/~nobody/g' test/helper-expand.c
  '';

  postFixup = ''
    substituteInPlace "$out"/bin/rofi-theme-selector \
        --replace "%ROFIOUT%" "$out/share"
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libxkbcommon pango cairo git bison flex librsvg check
    libstartup_notification libxcb xcbutil xcbutilwm xcbutilxrm which
  ];
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Window switcher, run dialog and dmenu replacement";
    homepage = https://davedavenport.github.io/rofi;
    license = licenses.mit;
    maintainers = with maintainers; [ mbakke garbas ];
    platforms = with platforms; unix;
  };
}
