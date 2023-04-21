{ lib, stdenv, writeText, python3Packages, fetchFromGitHub, gtk3, gobject-introspection, gdk-pixbuf, wrapGAppsHook, librsvg }:
python3Packages.buildPythonPackage rec {
  pname = "KlipperScreen";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "jordanruthe";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LweO5EVWr3OxziHrjtQDdWyUBCVUJ17afkw7RCZWgcg=";
  };
  patches = [ ./fix-paths.diff ];

  buildInputs = [ gtk3 librsvg ];
  nativeBuildInputs = [ wrapGAppsHook gdk-pixbuf gobject-introspection ];

  propagatedBuildInputs = with python3Packages; [ jinja2 netifaces requests websocket-client pycairo pygobject3 mpv six dbus-python numpy pycairo ];

  preBuild = ''
    ln -s ${./setup.py} setup.py
  '';

  meta = with lib; {
    description = "Touchscreen GUI for the Klipper 3D printer firmware";
    homepage = "https://github.com/jordanruthe/${pname}";
    license = licenses.agpl3;
  };
}
