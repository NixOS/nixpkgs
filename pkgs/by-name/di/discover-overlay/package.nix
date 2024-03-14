{ lib, python3, fetchFromGitHub, gtk3, gobject-introspection, wrapGAppsHook }:
python3.pkgs.buildPythonApplication rec {
  pname = "discover-overlay";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "trigg";
    repo = "Discover";
    rev = "v${version}";
    hash = "sha256-//QW6N87Uhm2aH0RSuykHG3+EfzYSHOcSNLSn1y0rFw=";
  };

  buildInputs = [ gtk3 ];

  nativeBuildInputs = with python3.pkgs; [
    gobject-introspection
    wrapGAppsHook
  ];

  makeWrapperArgs = [ "--set DISPLAY ':0.0'" ];

  propagatedBuildInputs = with python3.pkgs; [
    pycairo
    setuptools
    pygobject3
    websocket-client
    pyxdg
    requests
    pillow
    xlib
  ];

  doCheck = false;

  meta = with lib; {
    description = "Yet another discord overlay for linux";
    homepage = "https://github.com/trigg/Discover";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dragonginger ];
    mainProgram = "discover";
  };
}
