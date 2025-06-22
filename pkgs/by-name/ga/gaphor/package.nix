{
  lib,
  fetchFromGitHub,
  glib,
  gobject-introspection,
  wrapGAppsHook4,
  gtksourceview5,
  libadwaita,
  python3Packages,
  nix-update-script,
}:
python3Packages.buildPythonApplication rec {
  pname = "gaphor";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gaphor";
    repo = "gaphor";
    tag = version;
    hash = "sha256-0xivimpYM1gwOO2QrovYiJPNUfuGclr+F/WyHLNl+jw=";
  };

  pythonRelaxDeps = [
    "pydot"
    "pygobject"
  ];

  nativeBuildInputs = [
    glib
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    gtksourceview5
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

  postInstall = ''
    install -Dm644 data/org.gaphor.Gaphor.appdata.xml -t $out/share/metainfo/
    install -Dm644 data/org.gaphor.Gaphor.desktop -t $out/share/applications/
    install -Dm644 data/org.gaphor.Gaphor.xml -t $out/share/mime/packages/
    install -Dm644 data/logos/org.gaphor.Gaphor.svg -t $out/share/icons/hicolor/scalable/apps/
    install -Dm644 data/logos/org.gaphor.Gaphor-symbolic.svg -t $out/share/icons/hicolor/symbolic/apps/

    install -Dm644 data/logos/gaphor-24x24.png $out/share/icons/hicolor/24x24/apps/org.gaphor.Gaphor.png
    install -Dm644 data/logos/gaphor-48x48.png $out/share/icons/hicolor/48x48/apps/org.gaphor.Gaphor.png

    install -Dm644 gaphor/ui/installschemas/org.gaphor.Gaphor.gschema.xml -t $out/share/glib-2.0/schemas/
    glib-compile-schemas $out/share/glib-2.0/schemas/

    install -Dm644 data/org.gaphor.Gaphor.service -t $out/share/dbus-1/services/
    substituteInPlace $out/share/dbus-1/services/org.gaphor.Gaphor.service \
                      --replace-fail "Exec=/usr/bin/gaphor" "Exec=$out/bin/gaphor"
  '';

  # Prevent double wrapping
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
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
