{ lib
, stdenv
, fetchFromGitHub
, wrapGAppsHook
, cmake
, gettext
, maxima
, wxGTK
, gnome
, glib
}:

stdenv.mkDerivation rec {
  pname = "wxmaxima";
  version = "22.12.0";

  src = fetchFromGitHub {
    owner = "wxMaxima-developers";
    repo = "wxmaxima";
    rev = "Version-${version}";
    sha256 = "sha256-RT6y4M6LQD1fXJcjtdSXnDmoJvv160g2asdV4WtTcok=";
  };

  buildInputs = [
    wxGTK
    maxima
    # So it won't embed svg files into headers.
    gnome.adwaita-icon-theme
    # So it won't crash under Sway.
    glib
  ];

  nativeBuildInputs = [
    wrapGAppsHook
    cmake
    gettext
  ];

  cmakeFlags = [
    "-DwxWidgets_LIBRARIES=${wxGTK}/lib"
  ];

  preConfigure = ''
    gappsWrapperArgs+=(--prefix PATH ":" ${maxima}/bin)
  '';

  meta = with lib; {
    description = "Cross platform GUI for the computer algebra system Maxima";
    license = licenses.gpl2;
    homepage = "https://wxmaxima-developers.github.io/wxmaxima/";
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.linux;
  };
}
