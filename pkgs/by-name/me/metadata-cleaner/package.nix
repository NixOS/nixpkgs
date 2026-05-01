{
  lib,
  python3,
  fetchFromGitLab,
  appstream,
  desktop-file-utils,
  glib,
  gobject-introspection,
  gtk4,
  itstool,
  libadwaita,
  librsvg,
  meson,
  ninja,
  pkg-config,
  poppler_gi,
  wrapGAppsHook4,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "metadata-cleaner";
  version = "4.0.0";
  pyproject = false;

  src = fetchFromGitLab {
    owner = "metadatacleaner";
    repo = "metadatacleaner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9e8uH//FtufYUsvule3JirkeHTjDMebruZ3bAYyDVWY=";
  };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    glib # glib-compile-resources
    gtk4 # gtk4-update-icon-cache
    gobject-introspection
    itstool
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    librsvg
    poppler_gi
  ];

  dependencies = with python3.pkgs; [
    mat2
    pygobject3
  ];

  meta = {
    description = "Python GTK application to view and clean metadata in files, using mat2";
    mainProgram = "metadata-cleaner";
    homepage = "https://gitlab.com/metadatacleaner/metadatacleaner";
    changelog = "https://gitlab.com/metadatacleaner/metadatacleaner/-/releases/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      gpl3Plus
      cc-by-sa-40
    ];
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
