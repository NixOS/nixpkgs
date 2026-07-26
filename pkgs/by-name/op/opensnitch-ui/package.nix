{
  python3Packages,
  qt6,
  lib,
  opensnitch,
}:

python3Packages.buildPythonApplication {
  pyproject = true;
  pname = "opensnitch-ui";

  inherit (opensnitch) src version;
  sourceRoot = "${opensnitch.src.name}/ui";

  postPatch = ''
    substituteInPlace opensnitch/utils/__init__.py \
      --replace-fail /usr/lib/python3/dist-packages/data ${python3Packages.pyasn}/${python3Packages.python.sitePackages}/pyasn/data
  '';

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtwayland
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    grpcio-tools
    notify2
    packaging
    pyasn
    pyinotify
    pyqt6
    qt-material
    python-slugify
    unidecode
  ];

  preBuild = ''
    make -C ../proto ../ui/opensnitch/ui_pb2.py
    # sourced from ui/Makefile
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

  pythonImportsCheck = [ "opensnitch" ];

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
