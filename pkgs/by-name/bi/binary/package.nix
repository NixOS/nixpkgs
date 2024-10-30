{
  lib,
  fetchFromGitHub,
  python3Packages,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  glib,
  gobject-introspection,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication rec {
  pname = "binary";
  version = "5.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "fizzyizzy05";
    repo = "binary";
    rev = "refs/tags/${version}";
    hash = "sha256-T/gFXYcUJBN1NWMQaFco1bqqZTz3JHQpM8C2Y5yz7SI=";
  };

  nativeBuildInputs = [
    appstream
    blueprint-compiler
    desktop-file-utils
    glib # need glib-compile-schemas
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [ libadwaita ];

  dependencies = with python3Packages; [ pygobject3 ];

  dontWrapGApps = true;
  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  meta = {
    description = "Small and simple app to convert numbers to a different base";
    homepage = "https://github.com/fizzyizzy05/binary";
    changelog = "https://github.com/fizzyizzy05/binary/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "binary";
    platforms = lib.platforms.linux;
  };
}
