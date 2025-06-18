{
  lib,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  fetchFromGitHub,
  gdm,
  glib,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  python3Packages,
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
  version = "5.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "gdm-settings";
    repo = "gdm-settings";
    tag = "v${version}";
    hash = "sha256-x7w6m0+uwkm95onR+ioQAoLlaPoUmLc0+NgawQIIa/Y=";
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
