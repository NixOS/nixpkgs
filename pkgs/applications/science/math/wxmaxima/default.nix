{ stdenv, fetchFromGitHub
, wrapGAppsHook, cmake, gettext
, maxima, wxGTK, gnome3 }:

stdenv.mkDerivation rec {
  pname = "wxmaxima";
  version = "20.06.6";

  src = fetchFromGitHub {
    owner = "wxMaxima-developers";
    repo = "wxmaxima";
    rev = "Version-${version}";
    sha256 = "054f7n5kx75ng5j20rd5q27n9xxk03mrd7sbxyym1lsswzimqh4w";
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
