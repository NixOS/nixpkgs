{ lib, fetchFromGitHub, gobject-introspection, gtk3, gtksourceview3, wrapGAppsHook, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "skytemple";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    sha256 = "0l2c4qngv58j6zkp0va6m96zksx8gqn3mjc3isqybfnhjr6nd3v9";
  };

  buildInputs = [ gobject-introspection gtk3 gtksourceview3 ];
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
