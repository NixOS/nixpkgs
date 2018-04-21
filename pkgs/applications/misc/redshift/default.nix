{ stdenv, fetchFromGitHub, fetchurl, autoconf, automake, gettext, intltool
, libtool, pkgconfig, wrapGAppsHook, wrapPython, geoclue2, gobjectIntrospection
, gtk3, python, pygobject3, pyxdg, libdrm, libxcb, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  name = "redshift-${version}";
  version = "1.11";

  src = fetchFromGitHub {
    owner = "jonls";
    repo = "redshift";
    rev = "v${version}";
    sha256 = "0jfi4wqklqw2rm0r2xwalyzir88zkdvqj0z5id0l5v20vsrfiiyj";
  };

  patches = [
    # https://github.com/jonls/redshift/pull/575
    ./575.patch
  ];

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    intltool
    libtool
    pkgconfig
    wrapGAppsHook
    wrapPython
  ];

  buildInputs = [
    geoclue2
    gobjectIntrospection
    gtk3
    libdrm
    libxcb
    python
    hicolor-icon-theme
  ];

  pythonPath = [ pygobject3 pyxdg ];

  preConfigure = "./bootstrap";

  postFixup = "wrapPythonPrograms";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Screen color temperature manager";
    longDescription = ''
      Redshift adjusts the color temperature according to the position
      of the sun. A different color temperature is set during night and
      daytime. During twilight and early morning, the color temperature
      transitions smoothly from night to daytime temperature to allow
      your eyes to slowly adapt. At night the color temperature should
      be set to match the lamps in your room.
    '';
    license = licenses.gpl3Plus;
    homepage = http://jonls.dk/redshift;
    platforms = platforms.linux;
    maintainers = with maintainers; [ yegortimoshenko ];
  };
}
