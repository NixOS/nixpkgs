{ stdenv, fetchFromGitLab, pkgconfig, cmake, gettext, cairo, pango, pcre
, glib, imlib2, gtk2, libXinerama, libXrender, libXcomposite, libXdamage
, libX11, libXrandr, librsvg, libpthreadstubs, libXdmcp
, libstartup_notification, hicolor-icon-theme, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  name = "tint2-${version}";
  version = "16.6.1";

  src = fetchFromGitLab {
    owner = "o9000";
    repo = "tint2";
    rev = version;
    sha256 = "1h5bn4vi7gffwi4mpwpn0s6vxvl44rn3m9b23w8q9zyz9v24flz7";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig cmake gettext wrapGAppsHook ];

  buildInputs = [ cairo pango pcre glib imlib2 gtk2 libXinerama libXrender
    libXcomposite libXdamage libX11 libXrandr librsvg libpthreadstubs
    libXdmcp libstartup_notification hicolor-icon-theme ];

  postPatch = ''
    for f in ./src/launcher/apps-common.c \
             ./src/launcher/icon-theme-common.c
    do
      substituteInPlace $f --replace /usr/share/ /run/current-system/sw/share/
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://gitlab.com/o9000/tint2;
    description = "Simple panel/taskbar unintrusive and light (memory, cpu, aestetic)";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
