{ python3Packages
, lib
, qt5
, fetchFromGitHub
,
}:
let
  version = "1.3.3";
in
python3Packages.buildPythonApplication {
  pname = "sway-input-config";
  inherit version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Sunderland93";
    repo = "sway-input-config";
    rev = "v${version}";
    hash = "sha256-sZHjx5bmwZIoTDnEJ1/pfdqawk4JUJKA4Zhj2hoXeaQ=";
  };

  propagatedBuildInputs = with python3Packages; [ i3ipc pyside2 ];
  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  postFixup = ''
    wrapQtApp $out/bin/sway-input-config --prefix QT_PLUGIN_PATH : ${qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}
  '';

  meta = with lib; {
    description = "Input device configurator for Sway";
    homepage = "https://github.com/Sunderland93/sway-input-config";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mightyiam ];
  };
}
