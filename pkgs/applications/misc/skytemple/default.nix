{ lib
, fetchFromGitHub
, gobject-introspection
, gtk3
, gtksourceview4
, webkitgtk
, wrapGAppsHook3
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "skytemple";
  version = "1.6.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = "skytemple";
    rev = "refs/tags/${version}";
    hash = "sha256-yfXu1sboKi8STPiX5FUD9q+1U9GfhOyEKDRvU9rgdfI=";
  };

  build-system = with python3Packages; [ setuptools ];

  buildInputs = [
    gtk3
    gtksourceview4
    # webkitgtk is used for rendering interactive statistics graph which
    # can be seen by opening a ROM, entering Pokemon section, selecting
    # any Pokemon, and clicking Stats and Moves tab.
    webkitgtk
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  pythonRelaxDeps = [
    "skytemple-files"
    "skytemple-ssb-debugger"
  ];

  dependencies = with python3Packages; [
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
    wheel
  ] ++ skytemple-files.optional-dependencies.spritecollab;

  doCheck = false; # there are no tests

  postInstall = ''
    install -Dm444 org.skytemple.SkyTemple.desktop -t $out/share/applications
    install -Dm444 installer/skytemple.ico $out/share/icons/hicolor/256x256/apps/org.skytemple.SkyTemple.ico
  '';

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple";
    description = "ROM hacking tool for Pokémon Mystery Dungeon Explorers of Sky";
    mainProgram = "skytemple";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ marius851000 ];
  };
}
