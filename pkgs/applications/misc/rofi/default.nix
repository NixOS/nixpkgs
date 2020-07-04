{ stdenv, lib, fetchurl
, autoreconfHook, pkgconfig, libxkbcommon, pango, which, git
, cairo, libxcb, xcbutil, xcbutilwm, xcbutilxrm, libstartup_notification
, bison, flex, librsvg, check
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "rofi-unwrapped";
  version = "1.5.4";

  src = fetchurl {
    url = "https://github.com/davatorium/rofi/releases/download/${version}/rofi-${version}.tar.gz";
    sha256 = "1g1170zmh5v7slnm1sm2d08jgz6icikf8rm17apm1bjzzyw1lhk7";
  };

  preConfigure = ''
    patchShebangs "script"
    # root not present in build /etc/passwd
    sed -i 's/~root/~nobody/g' test/helper-expand.c
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig makeWrapper ];
  buildInputs = [ libxkbcommon pango cairo git bison flex librsvg check
    libstartup_notification libxcb xcbutil xcbutilwm xcbutilxrm which
  ];

  postInstall = ''
    wrapProgram $out/bin/rofi \
      --run 'export XDG_DATA_DIRS="$(sed "s| |/share:|g" < <(echo $NIX_PROFILES))/share:$XDG_DATA_DIRS"'
  '';

  doCheck = false;

  meta = with lib; {
    description = "Window switcher, run dialog and dmenu replacement";
    homepage = "https://github.com/davatorium/rofi";
    license = licenses.mit;
    maintainers = with maintainers; [ mbakke ];
    platforms = with platforms; linux;
  };
}
