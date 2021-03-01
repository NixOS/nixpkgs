{ lib, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wrapGAppsHook
, gtk3
, gtksourceview
, gtkspell3
, webkitgtk
, pandoc
}:

stdenv.mkDerivation rec {
  pname = "marker";
  version = "2020.04.04";

  src = fetchFromGitHub {
    owner = "fabiocolacio";
    repo = "Marker";
    rev = version;
    fetchSubmodules = true;
    sha256 = "1iy7izyprf050bix8am1krqivgyxnhx3jm775v8f80cgbqxy7m5r";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    gtksourceview
    gtkspell3
    webkitgtk
    pandoc
  ];

  meta = with lib; {
    homepage = "https://fabiocolacio.github.io/Marker/";
    description = "Markdown editor for the Linux desktop";
    maintainers = with maintainers; [ trepetti ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    changelog = "https://github.com/fabiocolacio/Marker/releases/tag/${version}";
  };
}
