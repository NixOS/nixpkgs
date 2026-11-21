{
  lib,
  python3Packages,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mousam";
  version = "3.0.0";
  # built with meson, not a python format
  pyproject = false;

  src = fetchFromGitHub {
    owner = "amit9838";
    repo = "mousam";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Kk9vGVqUlkU71UBzrSTddi6A7nDbvj7S4VZT6bKhcmw=";
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
    requests
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Beautiful and lightweight weather app based on Python and GTK4";
    homepage = "https://amit9838.github.io/mousam";
    license = lib.licenses.gpl3Plus;
    mainProgram = "mousam";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})
