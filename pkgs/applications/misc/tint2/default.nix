{ stdenv, fetchFromGitLab, pkgconfig, cmake, gettext, pango, cairo, glib
, pcre , imlib2, libXinerama , libXrender, libXcomposite, libXdamage, libX11
, libXrandr, gtk, libpthreadstubs , libXdmcp, librsvg
, libstartup_notification, hicolor_icon_theme, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  name = "tint2-${version}";
  version = "0.12.11";

  src = fetchFromGitLab {
    owner = "o9000";
    repo = "tint2";
    rev = version;
    sha256 = "0gfxbxslc8h95q7cq84a69yd7qdhyks978l3rmk48jhwwixdp0hr";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig cmake gettext wrapGAppsHook ];

  buildInputs = [ pango cairo glib pcre imlib2 libXinerama libXrender
    libXcomposite libXdamage libX11 libXrandr gtk libpthreadstubs libXdmcp
    librsvg libstartup_notification hicolor_icon_theme ];

  preConfigure = ''
    substituteInPlace CMakeLists.txt --replace /etc $out/etc
  '';

  prePatch = ''
    for f in ./src/tint2conf/properties.c \
             ./src/launcher/apps-common.c \
             ./src/launcher/icon-theme-common.c \
             ./themes/*tint2rc
    do
      substituteInPlace $f --replace /usr/share/ /run/current-system/sw/share/
    done
  '';

  meta = {
    homepage = https://gitlab.com/o9000/tint2;
    description = "Simple panel/taskbar unintrusive and light (memory, cpu, aestetic)";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
