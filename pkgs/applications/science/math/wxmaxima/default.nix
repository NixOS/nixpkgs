{ stdenv, fetchFromGitHub
, wrapGAppsHook, autoreconfHook, gettext
, maxima, wxGTK, gnome3 }:

stdenv.mkDerivation rec {
  name = "wxmaxima-${version}";
  version = "17.10.1";

  src = fetchFromGitHub {
    owner = "andrejv";
    repo = "wxmaxima";
    rev = "Version-${version}";
    sha256 = "088h8dlc9chkppwl4ck9i0fgf2d1dcpi5kq8qbpr5w75vhwsb6qm";
  };

  buildInputs = [ wxGTK maxima gnome3.defaultIconTheme ];

  nativeBuildInputs = [ wrapGAppsHook autoreconfHook gettext ];

  preConfigure = ''
    gappsWrapperArgs+=(--prefix PATH ":" ${maxima}/bin)
  '';

  doCheck = true;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Cross platform GUI for the computer algebra system Maxima";
    license = licenses.gpl2;
    homepage = http://wxmaxima.sourceforge.net;
    platforms = platforms.linux;
    maintainers = [ maintainers.peti ];
  };
}
