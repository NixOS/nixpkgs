{ stdenv, fetchurl, autoreconfHook, pkgconfig
, libX11, libxkbcommon, pango, cairo, glib
, libxcb, xcbutil, xcbutilwm, which, git
, libstartup_notification, i3Support ? false, i3
}:

stdenv.mkDerivation rec {
  name = "rofi-${version}";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/DaveDavenport/rofi/releases/download/${version}/${name}.tar.xz";
    sha256 = "0ard95pjgykafm5ga8lfy7x206f07lrc6kara5s9irlhdgblq2m5";
  };

  preConfigure = ''
    patchShebangs "script"
    # root not present in build /etc/passwd
    sed -i 's/~root/~nobody/g' test/helper-expand.c
  '';

  buildInputs = [ autoreconfHook pkgconfig libX11 libxkbcommon pango
                  cairo libstartup_notification libxcb xcbutil xcbutilwm
                  which git
                ] ++ stdenv.lib.optional i3Support i3;

  doCheck = true;

  meta = {
      description = "Window switcher, run dialog and dmenu replacement";
      homepage = https://davedavenport.github.io/rofi;
      license = stdenv.lib.licenses.mit;
      maintainers = [ stdenv.lib.maintainers.mbakke ];
  };
}
