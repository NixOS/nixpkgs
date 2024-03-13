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

stdenv.mkDerivation (finalAttrs:{
  pname = "wxmaxima";
  version = "24.02.2";

  src = fetchFromGitHub {
    owner = "wxMaxima-developers";
    repo = "wxmaxima";
    rev = "Version-${finalAttrs.version}";
    hash = "sha256-ewyg+ZhbRbPjJkYTZFuhbOWMDNZGW7ejmSv38zxcTsw=";
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
})
