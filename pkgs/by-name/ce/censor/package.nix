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
  libxml2,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "censor";
  version = "0.10.1";
  pyproject = false;

  src = fetchFromCodeberg {
    owner = "censor";
    repo = "Censor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cNUokMWbvwPIq6gdnwkPwMWBlqo3HjqLeSyPyEDYrts=";
  };

  postPatch = ''
    patchShebangs po/build.sh
  '';

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    libxml2 # xmllint
    meson
    ninja
    pkg-config
    wrapGAppsHook4
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
