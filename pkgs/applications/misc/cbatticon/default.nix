{ stdenv, fetchFromGitHub, pkgconfig, gettext, glib, gtk3, libnotify, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "cbatticon";
  version = "1.6.10";

  src = fetchFromGitHub {
    owner = "valr";
    repo = pname;
    rev = version;
    sha256 = "0ivm2dzhsa9ir25ry418r2qg2llby9j7a6m3arbvq5c3kaj8m9jr";
  };

  nativeBuildInputs = [ pkgconfig gettext wrapGAppsHook ];

  buildInputs =  [ glib gtk3 libnotify ];

  patchPhase = ''
    sed -i -e 's/ -Wno-format//g' Makefile
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    description = "Lightweight and fast battery icon that sits in the system tray";
    homepage = https://github.com/valr/cbatticon;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.domenkozar ];
  };
}
