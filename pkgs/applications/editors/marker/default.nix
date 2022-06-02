{ stdenv
, lib
, fetchFromGitHub
, itstool
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
  version = "2020.04.04.2";

  src = fetchFromGitHub {
    owner = "fabiocolacio";
    repo = "Marker";
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-wLR1FQqlLA02ed/JoAcxRHhIVua1FibAee1PC2zOPOM=";
  };

  nativeBuildInputs = [
    itstool
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
