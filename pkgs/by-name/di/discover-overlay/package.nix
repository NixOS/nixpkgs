{ lib, python3, fetchFromGitHub, gtk3, gobject-introspection, gtk-layer-shell, wrapGAppsHook }:
python3.pkgs.buildPythonApplication rec {
  pname = "discover-overlay";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trigg";
    repo = "Discover";
    rev = "refs/tags/v${version}";
    hash = "sha256-//QW6N87Uhm2aH0RSuykHG3+EfzYSHOcSNLSn1y0rFw=";
  };

  buildInputs = [
    gtk3
    gtk-layer-shell
  ];

  nativeBuildInputs = with python3.pkgs; [
    gobject-introspection
    wrapGAppsHook
  ];

  dontWrapGApps = true;

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" "--set DISPLAY ':0.0'" ];

  propagatedBuildInputs = with python3.pkgs; [
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
