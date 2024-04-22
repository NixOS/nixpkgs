{ lib
, python3
, fetchFromGitHub
, wrapGAppsHook
, gobject-introspection
, gitUpdater
}: python3.pkgs.buildPythonApplication rec {
  pname = "KlipperScreen";
  version = "0.3.2";
  format = "other";

  src = fetchFromGitHub {
    owner = "jordanruthe";
    repo = "KlipperScreen";
    rev = "v${version}";
    hash = "sha256-LweO5EVWr3OxziHrjtQDdWyUBCVUJ17afkw7RCZWgcg=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook
  ];

  pythonPath = with python3.pkgs; [
    jinja2
    netifaces
    requests
    websocket-client
    pycairo
    pygobject3
    mpv
    six
    dbus-python
  ];

  dontWrapGApps = true;

  preFixup = ''
    mkdir -p $out/bin
    cp -r . $out/dist
    gappsWrapperArgs+=(--set PYTHONPATH "$PYTHONPATH")
    wrapGApp $out/dist/screen.py
    ln -s $out/dist/screen.py $out/bin/KlipperScreen
  '';

  passthru.updateScript = gitUpdater { url = meta.homepage; };

  meta = with lib; {
    description = "Touchscreen GUI for the Klipper 3D printer firmware";
    homepage = "https://github.com/jordanruthe/KlipperScreen";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ cab404 ];
    mainProgram = "KlipperScreen";
  };
}
