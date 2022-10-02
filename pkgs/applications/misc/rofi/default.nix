{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, libxkbcommon
, pango
, which
, git
, cairo
, libxcb
, xcbutil
, xcbutilwm
, xcbutilxrm
, xcb-util-cursor
, libstartup_notification
, bison
, flex
, librsvg
, check
, glib
, buildPackages
}:

stdenv.mkDerivation rec {
  pname = "rofi-unwrapped";
  version = "1.7.5";

  src = fetchFromGitHub {
    owner = "davatorium";
    repo = "rofi";
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-3XFusKeckagEPfbLtt1xAVTEfn1Qebdi/Iq1AYbHCR4=";
  };

  preConfigure = ''
    patchShebangs "script"
    # root not present in build /etc/passwd
    sed -i 's/~root/~nobody/g' test/helper-expand.c
  '';

  depsBuildBuild = [ buildPackages.stdenv.cc pkg-config glib ];
  nativeBuildInputs = [ meson ninja pkg-config flex bison ];
  buildInputs = [
    libxkbcommon
    pango
    cairo
    git
    librsvg
    check
    libstartup_notification
    libxcb
    xcbutil
    xcbutilwm
    xcbutilxrm
    xcb-util-cursor
    which
  ];

  doCheck = false;

  meta = with lib; {
    description = "Window switcher, run dialog and dmenu replacement";
    homepage = "https://github.com/davatorium/rofi";
    license = licenses.mit;
    maintainers = with maintainers; [ bew ];
    platforms = with platforms; linux;
  };
}
