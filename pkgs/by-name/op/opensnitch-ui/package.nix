{
  python3Packages,
  qt5,
  lib,
  opensnitch,
}:

python3Packages.buildPythonApplication {
  format = "setuptools";
  pname = "opensnitch-ui";

  inherit (opensnitch) src version;
  sourceRoot = "${opensnitch.src.name}/ui";

  postPatch = ''
    substituteInPlace opensnitch/utils/__init__.py \
      --replace-fail /usr/lib/python3/dist-packages/data ${python3Packages.pyasn}/${python3Packages.python.sitePackages}/pyasn/data
  '';

  nativeBuildInputs = [
    python3Packages.pyqt5
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    qt5.qtwayland
  ];

  dependencies = with python3Packages; [
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
    sed -i 's/^import ui_pb2/from . import ui_pb2/' opensnitch/proto/ui_pb2*
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

  meta = {
    description = "Application firewall";
    mainProgram = "opensnitch-ui";
    homepage = "https://github.com/evilsocket/opensnitch/wiki";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      onny
      grimmauld
    ];
    platforms = lib.platforms.linux;
  };
}
