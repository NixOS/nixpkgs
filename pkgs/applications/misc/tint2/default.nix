{ stdenv
, fetchFromGitLab
, pkg-config
, cmake
, gettext
, cairo
, pango
, pcre
, glib
, imlib2
, gtk2
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
  version = "16.7";

  src = fetchFromGitLab {
    owner = "o9000";
    repo = "tint2";
    rev = version;
    sha256 = "1937z0kixb6r82izj12jy4x8z4n96dfq1hx05vcsvsg1sx3wxgb0";
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
    gtk2
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

  meta = with stdenv.lib; {
    homepage = "https://gitlab.com/o9000/tint2";
    description = "Simple panel/taskbar unintrusive and light (memory, cpu, aestetic)";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
