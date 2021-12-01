{ lib, stdenv
, fetchFromGitLab
, pkg-config
, cmake
, gettext
, cairo
, pango
, pcre
, glib
, imlib2
, gtk3
, libXinerama
, libXrender
, libXcomposite
, libXdamage
, libX11
, libXrandr
, librsvg
, libpthreadstubs
, libXdmcp
, libstartup_notification
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "tint2";
  version = "17.0.1";

  src = fetchFromGitLab {
    owner = "o9000";
    repo = "tint2";
    rev = version;
    sha256 = "sha256-yiXdG0qYcdol2pA1L9ii4XiLZyyUAl8/EJop48OLoXs=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    gettext
    wrapGAppsHook
  ];

  buildInputs = [
    cairo
    pango
    pcre
    glib
    imlib2
    gtk3
    libXinerama
    libXrender
    libXcomposite
    libXdamage
    libX11
    libXrandr
    librsvg
    libpthreadstubs
    libXdmcp
    libstartup_notification
  ];

  cmakeFlags = [
    "-Ddocdir=share/doc/${pname}"
  ];

  postPatch = ''
    for f in ./src/launcher/apps-common.c \
             ./src/launcher/icon-theme-common.c
    do
      substituteInPlace $f --replace /usr/share/ /run/current-system/sw/share/
    done
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/o9000/tint2";
    description = "Simple panel/taskbar unintrusive and light (memory, cpu, aestetic)";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
