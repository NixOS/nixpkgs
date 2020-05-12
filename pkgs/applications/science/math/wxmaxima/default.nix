{ stdenv, fetchFromGitHub
, wrapGAppsHook, cmake, gettext
, maxima, wxGTK, gnome3 }:

stdenv.mkDerivation rec {
  pname = "wxmaxima";
  version = "20.02.4";

  src = fetchFromGitHub {
    owner = "wxMaxima-developers";
    repo = "wxmaxima";
    rev = "Version-${version}";
    sha256 = "106a7jrjwfmymzj70nsv44fm3jbxngr8pmkaghhpwy0ln38lhf54";
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
