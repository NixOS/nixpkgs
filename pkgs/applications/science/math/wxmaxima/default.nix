{ lib, stdenv, fetchFromGitHub
, wrapGAppsHook, cmake, gettext
, maxima, wxGTK, gnome }:

stdenv.mkDerivation rec {
  pname = "wxmaxima";
  version = "21.05.2";

  src = fetchFromGitHub {
    owner = "wxMaxima-developers";
    repo = "wxmaxima";
    rev = "Version-${version}";
    sha256 = "sha256-HPqdxGrPxe5FZNOimTpAP+c9VpDBkXu3Z1c1Aaf3+UA=";
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
  };
}
