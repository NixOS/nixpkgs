{ lib
, python3Packages
, fetchFromGitHub
, wrapQtAppsHook
, cups
}:

with python3Packages;

buildPythonApplication rec {
  pname = "inkcut";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0px0xdv6kyzkkpmvryrdfavv1qy2xrqdxkpmhvx1gj649xcabv32";
  };

  postPatch = ''
    substituteInPlace inkcut/device/transports/printer/plugin.py \
      --replace ", 'lpr', " ", '${cups}/bin/lpr', "
  '';

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
