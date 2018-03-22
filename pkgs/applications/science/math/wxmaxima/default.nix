{ stdenv, fetchFromGitHub
, wrapGAppsHook, cmake, gettext
, maxima, wxGTK, gnome3 }:

stdenv.mkDerivation rec {
  name = "wxmaxima-${version}";
  version = "18.02.0";

  src = fetchFromGitHub {
    owner = "andrejv";
    repo = "wxmaxima";
    rev = "Version-${version}";
    sha256 = "0s7bdykc77slqix28cyaa6x8wvxrn8461mkdgxflvi2apwsl56aa";
  };

  buildInputs = [ wxGTK maxima gnome3.defaultIconTheme ];

  nativeBuildInputs = [ wrapGAppsHook cmake gettext ];

  preConfigure = ''
    gappsWrapperArgs+=(--prefix PATH ":" ${maxima}/bin)
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Cross platform GUI for the computer algebra system Maxima";
    license = licenses.gpl2;
    homepage = http://wxmaxima.sourceforge.net;
    platforms = platforms.linux;
    maintainers = [ maintainers.peti ];
  };
}
