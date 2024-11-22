{
  lib,
  fetchFromGitHub,
  python3Packages,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  glib,
  gdm,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  # gdm-settings needs to know where to look for themes
  # This should work for most systems, but can be overridden if not
  dataDirs ? lib.concatStringsSep ":" [
    "/run/current-system/sw/share"
    "/usr/local/share"
    "/usr/share"
  ],
}:

python3Packages.buildPythonApplication rec {
  pname = "gdm-settings";
  version = "4.4";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "gdm-settings";
    repo = "gdm-settings";
    rev = "refs/tags/v${version}";
    hash = "sha256-3Te8bhv2TkpJFz4llm1itRhzg9v64M7Drtrm4s9EyiQ=";
  };

  nativeBuildInputs = [
    appstream # for appstream file validation
    blueprint-compiler
    desktop-file-utils # for desktop file validation
    glib # for `glib-compile-schemas`
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [ libadwaita ];

  dependencies = [ python3Packages.pygobject3 ];

  dontWrapGApps = true;
  makeWrapperArgs = [
    "\${gappsWrapperArgs[@]}"
    "--set-default HOST_DATA_DIRS ${dataDirs}"
  ];

  pythonImportsCheck = [ "gdms" ];

  meta = {
    description = "Settings app for GNOME's Login Manager";
    homepage = "https://gdm-settings.github.io/";
    changelog = "https://github.com/gdm-settings/gdm-settings/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "gdm-settings";
    inherit (gdm.meta) platforms;
  };
}
