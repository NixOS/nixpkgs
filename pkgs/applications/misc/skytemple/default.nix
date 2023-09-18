{ lib
, fetchFromGitHub
, gobject-introspection
, gtk3
, gtksourceview4
, webkitgtk
, wrapGAppsHook
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "skytemple";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-7sv0TzYMQLEaohy45JPPiK2wS3x4sXaevT/BfHaSbWw=";
  };

  buildInputs = [
    gtk3
    gtksourceview4
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
  ] ++ skytemple-files.optional-dependencies.spritecollab;

  doCheck = false; # there are no tests

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple";
    description = "ROM hacking tool for Pokémon Mystery Dungeon Explorers of Sky";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xfix marius851000 ];
  };
}
