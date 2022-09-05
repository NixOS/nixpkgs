{ lib
, fetchFromGitHub
, gobject-introspection
, gtk3
, gtksourceview3
, webkitgtk
, wrapGAppsHook
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "skytemple";
  version = "1.3.10";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    hash = "sha256-CyYGTXdQsGpDR/gpqViEQO1xUPHaXTES592nRJixa1o=";
  };

  buildInputs = [
    gobject-introspection
    gtk3
    gtksourceview3
    # webkitgkt is used for rendering interactive statistics graph which
    # can be seen by opening a ROM, entering Pokemon section, selecting
    # any Pokemon, and clicking Stats and Moves tab.
    webkitgtk
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook
  ];

  propagatedBuildInputs = with python3Packages; [
    cairosvg
    natsort
    ndspy
    packaging
    pycairo
    pygal
    psutil
    gbulb
    pypresence
    sentry-sdk
    setuptools
    skytemple-dtef
    skytemple-eventserver
    skytemple-files
    skytemple-icons
    skytemple-ssb-debugger
    tilequant
  ];

  doCheck = false; # there are no tests

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple";
    description = "ROM hacking tool for Pokémon Mystery Dungeon Explorers of Sky";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xfix marius851000 ];
  };
}
