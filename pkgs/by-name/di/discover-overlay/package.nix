{
  lib,
  python3,
  fetchFromGitHub,
  gtk3,
  gobject-introspection,
  gtk-layer-shell,
  wrapGAppsHook3,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "discover-overlay";
  version = "0.7.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trigg";
    repo = "Discover";
    tag = "v${version}";
    hash = "sha256-Z554/zRikZztdD4NZiDDjMWgIlnQDGkemlA3ONRhqR8=";
  };

  buildInputs = [
    gtk3
    gtk-layer-shell
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  dontWrapGApps = true;

  makeWrapperArgs = [
    "\${gappsWrapperArgs[@]}"
    "--set DISPLAY ':0.0'"
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pulsectl-asyncio
    pycairo
    pygobject3
    websocket-client
    pyxdg
    requests
    pillow
    setuptools
    xlib
  ];
  postPatch = ''
    substituteInPlace discover_overlay/image_getter.py \
      --replace-fail /usr $out
  '';
  doCheck = false;

  meta = {
    description = "Yet another discord overlay for linux";
    homepage = "https://github.com/trigg/Discover";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dragonginger ];
    mainProgram = "discover-overlay";
    platforms = lib.platforms.linux;
  };
}
