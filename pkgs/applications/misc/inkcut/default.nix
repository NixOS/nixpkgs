{ lib
, fetchpatch
, python3Packages
, fetchFromGitHub
, wrapQtAppsHook
, cups
}:

with python3Packages;

buildPythonApplication rec {
  pname = "inkcut";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-S5IrNWVoUp1w+P7DrKlOUOyY3Q16CHSct9ndZOB3UpU=";
  };

  patches = [
    # fix opening the extension on inkscape 1.2
    # https://github.com/inkcut/inkcut/pull/340
    (fetchpatch {
      url = "https://github.com/inkcut/inkcut/commit/d5d5d0ab3c588c576b668f4c7b07a10609ba2fd0.patch";
      hash = "sha256-szfiOujuV7OOwYK/OU51m9FK6dzkbWds+h0cr5dGIg4=";
    })
    # fix loading a document from stdin (as used from the extension)
    # https://github.com/inkcut/inkcut/issues/341
    (fetchpatch {
      url = "https://github.com/inkcut/inkcut/commit/748ab4157f87afec37dadd715094e87d02c9c739.patch";
      hash = "sha256-ZGiwZru2bUYu749YSz5vxmGwLTAoYIAsafcX6PmdbYo=";
      revert = true;
    })
    # fix distutils deprecation error
    # https://github.com/inkcut/inkcut/pull/343
    (fetchpatch {
      url = "https://github.com/inkcut/inkcut/commit/9fb95204981bcc51401a1bc10caa02d1fae0d6cb.patch";
      hash = "sha256-nriys7IWPGykZjVz+DIDsE9Tm40DewkHQlIUaxFwtzM=";
    })
  ];

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
  makeWrapperArgs = [ "--unset" "PYTHONPATH" "\${qtWrapperArgs[@]}" ];

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
