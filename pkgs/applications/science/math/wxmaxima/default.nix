{ lib, stdenv, fetchFromGitHub
, wrapGAppsHook, cmake, gettext
, maxima, wxGTK, gnome }:

stdenv.mkDerivation rec {
  pname = "wxmaxima";
  version = "21.02.0";

  src = fetchFromGitHub {
    owner = "wxMaxima-developers";
    repo = "wxmaxima";
    rev = "Version-${version}";
    sha256 = "sha256-5nvaaKsvSEs7QxOszjDK1Xkana2er1BCMZ83b1JZSqc=";
  };

  buildInputs = [ wxGTK maxima gnome.adwaita-icon-theme ];

  nativeBuildInputs = [ wrapGAppsHook cmake gettext ];

  preConfigure = ''
    gappsWrapperArgs+=(--prefix PATH ":" ${maxima}/bin)
  '';

  meta = with lib; {
    description = "Cross platform GUI for the computer algebra system Maxima";
    license = licenses.gpl2;
    homepage = "https://wxmaxima-developers.github.io/wxmaxima/";
    platforms = platforms.linux;
    maintainers = [ maintainers.peti ];
  };
}
