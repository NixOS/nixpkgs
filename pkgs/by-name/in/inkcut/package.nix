{
  lib,
  python3,
  fetchFromGitHub,
  cups,
  qt6,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "inkcut";
  version = "2.1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inkcut";
    repo = "inkcut";
    tag = "v${version}";
    hash = "sha256-inB3yR4ykepN5rYzyPlXW/J/HuSxGs6EDhshpa7n7o8=";
  };

  postPatch = ''
    substituteInPlace inkcut/device/transports/printer/plugin.py \
      --replace-fail ", 'lpr', " ", '${cups}/bin/lpr', "
  '';

  nativeBuildInputs = [ qt6.wrapQtAppsHook ];

  buildInputs = [ qt6.qtbase ];

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    enamlx
    twisted
    lxml
    qreactor
    jsonpickle
    pyserial
    pycups
    qtconsole
    pyqt6
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
  makeWrapperArgs = [
    "--unset"
    "PYTHONPATH"
    "\${qtWrapperArgs[@]}"
  ];

  postInstall = ''
    mkdir -p $out/share/inkscape/extensions

    cp plugins/inkscape/* $out/share/inkscape/extensions

    sed -i "s|cmd = \['inkcut'\]|cmd = \['$out/bin/inkcut'\]|" $out/share/inkscape/extensions/inkcut_cut.py
    sed -i "s|cmd = \['inkcut'\]|cmd = \['$out/bin/inkcut'\]|" $out/share/inkscape/extensions/inkcut_open.py
  '';

  meta = {
    homepage = "https://www.codelv.com/projects/inkcut/";
    description = "Control 2D plotters, cutters, engravers, and CNC machines";
    mainProgram = "inkcut";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ raboof ];
  };
}
