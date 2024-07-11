{ python3Packages
, fetchFromGitHub
, qt5
, lib
}:

python3Packages.buildPythonApplication rec {
  pname = "opensnitch-ui";
  version = "1.6.5.1";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = "opensnitch";
    rev = "refs/tags/v${version}";
    hash = "sha256-IVrAAHzLS7A7cYhRk+IUx8/5TGKeqC7M/7iXOpPe2ZA=";
  };

  postPatch = ''
    substituteInPlace ui/opensnitch/utils/__init__.py \
      --replace /usr/lib/python3/dist-packages/data ${python3Packages.pyasn}/${python3Packages.python.sitePackages}/pyasn/data
  '';

  nativeBuildInputs = [
    python3Packages.pyqt5
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    qt5.qtwayland
  ];

  propagatedBuildInputs = with python3Packages; [
    grpcio-tools
    notify2
    pyasn
    pyinotify
    pyqt5
    qt-material
    unicode-slugify
    unidecode
  ];

  preBuild = ''
    make -C ../proto ../ui/opensnitch/ui_pb2.py
    # sourced from ui/Makefile
    pyrcc5 -o opensnitch/resources_rc.py opensnitch/res/resources.qrc
    sed -i 's/^import ui_pb2/from . import ui_pb2/' opensnitch/ui_pb2*
  '';

  preConfigure = ''
    cd ui
  '';

  preCheck = ''
    export PYTHONPATH=opensnitch:$PYTHONPATH
  '';

  postInstall = ''
    mv $out/${python3Packages.python.sitePackages}/usr/* $out/
  '';

  dontWrapQtApps = true;
  makeWrapperArgs = [ "\${qtWrapperArgs[@]}" ];

  # All tests are sandbox-incompatible and disabled for now
  doCheck = false;

  meta = with lib; {
    description = "Application firewall";
    mainProgram = "opensnitch-ui";
    homepage = "https://github.com/evilsocket/opensnitch/wiki";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.linux;
  };
}
