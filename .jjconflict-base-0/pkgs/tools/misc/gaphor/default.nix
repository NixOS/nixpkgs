{
  lib,
  buildPythonApplication,
  fetchPypi,
  copyDesktopItems,
  gobject-introspection,
  poetry-core,
  wrapGAppsHook4,
  gtksourceview5,
  libadwaita,
  pango,
  gaphas,
  generic,
  jedi,
  pycairo,
  pillow,
  dulwich,
  pydot,
  defusedxml,
  better-exceptions,
  babel,
  pygobject3,
  tinycss2,
  gtk4,
  librsvg,
  makeDesktopItem,
  python,
}:

buildPythonApplication rec {
  pname = "gaphor";
  version = "2.27.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MsbEeOop6Osq2Hn6CkorsXt8/bTY//QHW/uCl0FEUN4=";
  };

  pythonRelaxDeps = [ "defusedxml" ];

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

  build-system = [ poetry-core ];

  dependencies = [
    pycairo
    pygobject3
    gaphas
    generic
    tinycss2
    babel
    jedi
    better-exceptions
    pydot
    pillow
    defusedxml
    dulwich
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

  postInstall = ''
    install -Dm644 $out/${python.sitePackages}/gaphor/ui/icons/hicolor/scalable/apps/org.gaphor.Gaphor.svg $out/share/pixmaps/gaphor.svg
  '';

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}" \
      --prefix XDG_DATA_DIRS : "${gtk4}/share/gsettings-schemas/${gtk4.name}/" \
      --set GDK_PIXBUF_MODULE_FILE "${librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"
    )
  '';

  meta = with lib; {
    description = "Simple modeling tool written in Python";
    maintainers = [ ];
    homepage = "https://github.com/gaphor/gaphor";
    license = licenses.asl20;
    platforms = lib.platforms.linux;
  };
}
