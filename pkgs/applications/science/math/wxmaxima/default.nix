{ stdenv, fetchFromGitHub
, wrapGAppsHook, cmake, gettext
, maxima, wxGTK, gnome3 }:

stdenv.mkDerivation rec {
  pname = "wxmaxima";
  version = "20.04.0";

  src = fetchFromGitHub {
    owner = "wxMaxima-developers";
    repo = "wxmaxima";
    rev = "Version-${version}";
    sha256 = "0vrjxzfgmjdzm1rgl0crz4b4badl14jwh032y3xkcdvjl5j67lp3";
  };

  buildInputs = [ wxGTK maxima gnome3.adwaita-icon-theme ];

  nativeBuildInputs = [ wrapGAppsHook cmake gettext ];

  preConfigure = ''
    gappsWrapperArgs+=(--prefix PATH ":" ${maxima}/bin)
  '';

  meta = with stdenv.lib; {
    description = "Cross platform GUI for the computer algebra system Maxima";
    license = licenses.gpl2;
    homepage = "https://wxmaxima-developers.github.io/wxmaxima/";
    platforms = platforms.linux;
    maintainers = [ maintainers.peti ];
  };
}
