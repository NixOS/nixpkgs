{
  lib,
  python312,
  fetchPypi,
  qt5,
}:

python312.pkgs.buildPythonApplication rec {
  pname = "patray";
  version = "0.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-O8CBUexL2V1qI7bB/Lns3yjUvFOpC6spd/6asXa5+pw=";
  };

  patchPhase = ''
    sed -i '30i entry_points = { "console_scripts": [ "patray = patray.__main__:main" ] },' setup.py
    sed -i 's/production.txt/production.in/' setup.py
    sed -i '/pyside2/d' requirements/production.in
  '';

  build-system = with python312.pkgs; [ setuptools ];

  dependencies = with python312.pkgs; [
    pulsectl
    loguru
    cock
    pyside2
  ];

  doCheck = false;

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];
  postFixup = ''
    wrapQtApp $out/bin/patray --prefix QT_PLUGIN_PATH : ${qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}
  '';

  meta = with lib; {
    description = "Yet another tray pulseaudio frontend";
    homepage = "https://github.com/pohmelie/patray";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "patray";
  };
}
