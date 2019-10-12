{ stdenv, fetchFromGitHub
, wrapGAppsHook, cmake, gettext
, maxima, wxGTK, gnome3 }:

stdenv.mkDerivation rec {
  pname = "wxmaxima";
  version = "19.03.0";

  src = fetchFromGitHub {
    owner = "andrejv";
    repo = "wxmaxima";
    rev = "Version-${version}";
    sha256 = "0s7bdykc77slqix28cyaa6x8wvxrn8461mkdgxflvi2apwsl56aa";
  };

  buildInputs = [ wxGTK maxima gnome3.adwaita-icon-theme ];

  nativeBuildInputs = [ wrapGAppsHook cmake gettext ];

  preConfigure = ''
    gappsWrapperArgs+=(--prefix PATH ":" ${maxima}/bin)
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Cross platform GUI for the computer algebra system Maxima";
    license = licenses.gpl2;
    homepage = https://wxmaxima-developers.github.io/wxmaxima/;
    platforms = platforms.linux;
    maintainers = [ maintainers.peti ];
  };
}
