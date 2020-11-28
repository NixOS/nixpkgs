{ lib
, python3Packages
, fetchFromGitHub
, wrapQtAppsHook
}:

with python3Packages;

buildPythonApplication rec {
  pname = "inkcut";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1zn5i69f3kimcwdd2qkqd3hd1hq76a6i5wxxfb91ih2hj04vdbmx";
  };

  patches = [
    # https://github.com/inkcut/inkcut/pull/292 but downloaded
    # because of https://github.com/NixOS/nixpkgs/issues/32084
    ./avoid-name-clash-between-inkcut-and-extension.patch
  ];

  nativeBuildInputs = [ wrapQtAppsHook ];

  propagatedBuildInputs = [
    enamlx
    twisted
    lxml
    qreactor
    jsonpickle
    pyserial
    pycups
    qtconsole
    pyqt5
  ];

  # QtApplication.instance() does not work during tests?
  doCheck = false;

  pythonImportsCheck = [
    "inkcut"
    "inkcut.cli"
    "inkcut.console"
    "inkcut.core"
    "inkcut.device"
    "inkcut.job"
    "inkcut.joystick"
    "inkcut.monitor"
    "inkcut.preview"
  ];

  dontWrapQtApps = true;
  makeWrapperArgs = [ "\${qtWrapperArgs[@]}" ];

  postInstall = ''
    mkdir -p $out/share/inkscape/extensions

    cp plugins/inkscape/* $out/share/inkscape/extensions

    sed -i "s|cmd = \['inkcut'\]|cmd = \['$out/bin/inkcut'\]|" $out/share/inkscape/extensions/inkcut_cut.py
    sed -i "s|cmd = \['inkcut'\]|cmd = \['$out/bin/inkcut'\]|" $out/share/inkscape/extensions/inkcut_open.py
  '';

  meta = with lib; {
    homepage = "https://www.codelv.com/projects/inkcut/";
    description = "Control 2D plotters, cutters, engravers, and CNC machines";
    license = licenses.gpl3;
    maintainers = with maintainers; [ raboof ];
  };
}
