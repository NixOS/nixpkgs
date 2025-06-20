{
  lib,
  fetchPypi,
  copyDesktopItems,
  gobject-introspection,
  wrapGAppsHook4,
  gtksourceview5,
  libadwaita,
  pango,
  gtk4,
  librsvg,
  makeDesktopItem,
  python3Packages,
  nix-update-script,
}:
python3Packages.buildPythonApplication rec {
  pname = "gaphor";
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-I5n0XeZLQw4qje6gwh2aMu5Zo5tuXgESHhkR0xegaYM=";
  };

  pythonRelaxDeps = [
    "defusedxml"
    "gaphas"
    "pydot"
  ];

  nativeBuildInputs = [
    copyDesktopItems
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    gtksourceview5
    pango
    libadwaita
  ];

  build-system = [ python3Packages.poetry-core ];

  dependencies = with python3Packages; [
    babel
    better-exceptions
    defusedxml
    dulwich
    gaphas
    generic
    jedi
    pillow
    pycairo
    pydot
    pygobject3
    tinycss2
  ];

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = "gaphor";
      icon = "gaphor";
      comment = meta.description;
      desktopName = "Gaphor";
    })
  ];

  # Disable automatic wrapGAppsHook4 to prevent double wrapping
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}" \
      --prefix XDG_DATA_DIRS : "${gtk4}/share/gsettings-schemas/${gtk4.name}/" \
      --set GDK_PIXBUF_MODULE_FILE "${librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "UML and SysML modeling tool";
    longDescription = ''
      Gaphor is a UML, SysML, RAAML, and C4 modeling application. It
      is designed to be easy to use, while still being powerful.
      Gaphor implements a fully-compliant UML 2 data model, so it is
      much more than a picture drawing tool. You can use Gaphor to
      quickly visualize different aspects of a system as well as
      create complete, highly complex models.

      Gaphor provides four modeling languages: UML, SysML, RAAML and C4 and
      makes them accessible to beginners.
    '';
    homepage = "https://gaphor.org/";
    changelog = "https://github.com/gaphor/gaphor/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ normalcea ];
    teams = [ lib.teams.gnome-circle ];
    mainProgram = "gaphor";
    platforms = lib.platforms.linux;
  };
}
