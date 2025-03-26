{
  python311Packages,
  fetchFromGitHub,
  nix-update-script,
  qt5,
  lib,
}:

python311Packages.buildPythonApplication rec {
  pname = "opensnitch-ui";
  version = "1.6.8";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = "opensnitch";
    rev = "refs/tags/v${version}";
    hash = "sha256-zn5kBnINLt/qqAbka9wShFLWJoMJ6SXu2OL6V6uQ2IM=";
  };

  postPatch = ''
    substituteInPlace ui/opensnitch/utils/__init__.py \
      --replace /usr/lib/python3/dist-packages/data ${python311Packages.pyasn}/${python311Packages.python.sitePackages}/pyasn/data
  '';

  nativeBuildInputs = [
    python311Packages.pyqt5
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    qt5.qtwayland
  ];

  propagatedBuildInputs = with python311Packages; [
    grpcio-tools
    notify2
    packaging
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
    mv $out/${python311Packages.python.sitePackages}/usr/* $out/
  '';

  dontWrapQtApps = true;
  makeWrapperArgs = [ "\${qtWrapperArgs[@]}" ];

  # All tests are sandbox-incompatible and disabled for now
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Application firewall";
    mainProgram = "opensnitch-ui";
    homepage = "https://github.com/evilsocket/opensnitch/wiki";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.linux;
  };
}
