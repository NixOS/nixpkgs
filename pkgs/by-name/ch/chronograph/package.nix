{
  lib,
  python3Packages,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  blueprint-compiler,
  desktop-file-utils,
  wrapGAppsHook4,
  libadwaita,
  gst_all_1,
}:

python3Packages.buildPythonApplication rec {
  pname = "chronograph";
  version = "5.3.1";
  pyproject = false; # Built with meson

  src = fetchFromGitHub {
    owner = "Dzheremi2";
    repo = "Chronograph";
    tag = "v${version}";
    hash = "sha256-xSvlvDXKJaL4sKQE+h9XkffFm3/1rHROlGxZgerBlNg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    blueprint-compiler
    desktop-file-utils
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
  ];

  dependencies = with python3Packages; [
    pygobject3
    pyyaml
    mutagen
    pillow
    magic
    httpx
    requests
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(''${gappsWrapperArgs[@]})
  '';

  meta = {
    description = "Sync lyrics of your loved songs";
    homepage = "https://github.com/Dzheremi2/Chronograph";
    license = lib.licenses.gpl3Plus;
    mainProgram = "chronograph";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
}
