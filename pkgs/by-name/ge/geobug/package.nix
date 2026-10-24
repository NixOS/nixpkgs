{
  lib,
  python3Packages,
  fetchFromCodeberg,
  gobject-introspection,
  wrapGAppsHook4,
  geoclue2,
  libadwaita,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "geobug";
  version = "0.9.2";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "tpikonen";
    repo = "geobug";
    tag = finalAttrs.version;
    hash = "sha256-6UQkmoDtbBFXfbTXLeeBpmCTVJKFrRONpErW/F1eW2c=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook4
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies =
    (with python3Packages; [
      gpxpy
      pygobject3
    ])
    ++ [
      geoclue2
      libadwaita
    ];

  pythonImportsCheck = [
    "geobug"
  ];

  __structuredAttrs = true;

  meta = {
    description = "Adaptive GeoClue client";
    longDescription = ''
      Geobug is an adaptive client for GeoClue, the geolocation D-bus server from freedesktop.org. It can display your location information (coordinates, speed etc.) and save a track of your movements to a GPX-file.
    '';
    homepage = "https://codeberg.org/tpikonen/geobug";
    changelog = "https://codeberg.org/tpikonen/geobug/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      Luflosi
    ];
    mainProgram = "geobug";
  };
})
