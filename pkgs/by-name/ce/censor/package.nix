{
  lib,
  fetchFromCodeberg,
  python3Packages,
  wrapGAppsHook4,
  gobject-introspection,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  desktop-file-utils,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "censor";
  version = "0.7.1";
  pyproject = false;

  src = fetchFromCodeberg {
    owner = "censor";
    repo = "Censor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wimLSoejojVBdHnuzLxOW4QssJZpK0GTp64oIvtSqBk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
  ];

  dependencies = with python3Packages; [
    pygobject3
    pymupdf
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "PDF document redaction for the GNOME desktop";
    homepage = "https://codeberg.org/censor/Censor";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ onny ];
    mainProgram = "censor";
  };
})
