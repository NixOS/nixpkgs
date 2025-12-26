{
  lib,
  appstream-glib,
  blueprint-compiler,
  desktop-file-utils,
  fetchFromGitHub,
  glib,
  gobject-introspection,
  gtk4,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  python3Packages,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication rec {
  pname = "speedtest";
  version = "1.4.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Ketok4321";
    repo = "speedtest";
    tag = "v${version}";
    hash = "sha256-00qHHCGXAzV38BLUIENwxmWUhp+t7BsM7w6xu1Xs/UA=";
  };

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "run_command('git', 'describe', '--tags', check: false).stdout().strip()" "'v${version}'"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    appstream-glib
    blueprint-compiler
    desktop-file-utils # For `desktop-file-validate`
    glib # For `glib-compile-schemas`
    gobject-introspection
    gtk4 # For `gtk-update-icon-cache`
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  dependencies = [
    python3Packages.aiohttp
    python3Packages.pygobject3
  ];

  buildInputs = [ libadwaita ];

  dontWrapGAppsHook = true;

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  meta = {
    description = "Graphical librespeed client written using GTK4 + libadwaita";
    homepage = "https://github.com/Ketok4321/speedtest";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "speedtest";
    platforms = lib.platforms.linux;
  };
}
