{ lib, fetchFromGitHub, gobject-introspection, gtk3, gtksourceview3, webkitgtk, wrapGAppsHook, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "skytemple";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    sha256 = "0780517gjc97wb2g67pwdv3fz3sqxm2ica1hdbrhqm4rfbnb28xr";
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
  nativeBuildInputs = [ gobject-introspection wrapGAppsHook ];
  propagatedBuildInputs = with python3Packages; [
    natsort
    packaging
    pycairo
    pygal
    pypresence
    setuptools
    skytemple-dtef
    skytemple-eventserver
    skytemple-files
    skytemple-icons
    skytemple-ssb-debugger
  ];

  doCheck = false; # there are no tests

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple";
    description = "ROM hacking tool for Pokémon Mystery Dungeon Explorers of Sky";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xfix ];
  };
}
