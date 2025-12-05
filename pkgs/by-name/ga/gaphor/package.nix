{
  lib,
  fetchFromGitHub,
  glib,
  gobject-introspection,
  wrapGAppsHook4,
  gitMinimal,
  gtksourceview5,
  libadwaita,
  python3Packages,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:
python3Packages.buildPythonApplication rec {
  pname = "gaphor";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gaphor";
    repo = "gaphor";
    tag = version;
    hash = "sha256-0Z0RFQrN2g0beV2konZBfMroeNtbT+sPRsWlRvQFYBk=";
  };

  pythonRelaxDeps = [
    "pydot"
    "pygobject"
    "dulwich"
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
    ipython
    sphinx
  ];

  postInstall = ''
    install -Dm644 data/org.gaphor.Gaphor.appdata.xml -t $out/share/metainfo/
    install -Dm644 data/org.gaphor.Gaphor.desktop -t $out/share/applications/
    install -Dm644 data/org.gaphor.Gaphor.xml -t $out/share/mime/packages/
    install -Dm644 data/logos/org.gaphor.Gaphor.svg -t $out/share/icons/hicolor/scalable/apps/
    install -Dm644 data/logos/org.gaphor.Gaphor-symbolic.svg -t $out/share/icons/hicolor/symbolic/apps/

    install -Dm644 data/logos/gaphor-24x24.png $out/share/icons/hicolor/24x24/apps/org.gaphor.Gaphor.png
    install -Dm644 data/logos/gaphor-48x48.png $out/share/icons/hicolor/48x48/apps/org.gaphor.Gaphor.png

    GSCHEMA_PATH=$out/share/gsettings-schemas/$name/glib-2.0/schemas
    install -Dm644 gaphor/ui/installschemas/org.gaphor.Gaphor.gschema.xml -t $GSCHEMA_PATH
    glib-compile-schemas $GSCHEMA_PATH
    substituteInPlace $out/${python3Packages.python.sitePackages}/gaphor/settings.py \
      --replace-fail 'Gio.SettingsSchemaSource.get_default()' \
        "Gio.SettingsSchemaSource.new_from_directory('$GSCHEMA_PATH', Gio.SettingsSchemaSource.get_default(), False)"

    install -Dm644 data/org.gaphor.Gaphor.service -t $out/share/dbus-1/services/
    substituteInPlace $out/share/dbus-1/services/org.gaphor.Gaphor.service \
                      --replace-fail "Exec=/usr/bin/gaphor" "Exec=$out/bin/gaphor"
  '';

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    gitMinimal
  ]
  ++ (with python3Packages; [
    pytestCheckHook
    pytest-asyncio
    pytest-archon
    hypothesis
    xdoctest
    markdown-it-py
  ]);

  disabledTests = [
    # Segfault due to gtk initialization failure?
    "page"
    "editor"
    "drop"
  ];

  disabledTestPaths = [
    # Same, segfault
    "gaphor/diagram/tools/tests"
    "gaphor/plugins/console/tests"
    "gaphor/ui/tests"
    "gaphor/tests/test_application.py"
    "tests/*"
  ];

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
