{ lib
, fetchFromGitHub
, callPackage
, alice-vision
, python3
, qtbase
, qtdeclarative
, qttools
, qtquickcontrols
, qtquickcontrols2
, qtgraphicaleffects
, qt3d
, qtlocation
, qtcharts
, wrapQtAppsHook
, makeWrapper
}:

let
  validLocalVersion = s: builtins.match "^[a-zA-Z0-9.]+$" s != null;
  mkLocalVersion = s: let s' = lib.replaceStrings ["-"] ["."] s; in lib.throwIfNot (validLocalVersion s') "invalid local version ${s'}" s';
  qtalicevision = callPackage ./qtalicevision.nix { };
  qmlalembic = callPackage ./qmlalembic.nix { };

in
python3.pkgs.buildPythonApplication rec {
  pname = "meshroom";
  version = "unstable-2023-02-09";

  src = fetchFromGitHub {
    owner = "alicevision";
    repo = pname;
    rev = "334bfc8b00b6f82e8405a3c7537c8936abace124";
    hash = "sha256-RjayS1SfG17T5Xn5P6JBg5nNGZVSLuZ7X5aAWrlHVPg=";
  };

  format = "pyproject";

  ppl = ''
    [tool.poetry]
    name = "${pname}"
    version = "2021.1.0+${mkLocalVersion version}"
    description = "Meshroom"
    authors = ["nobody"]
    readme = "README.md"
    packages = [{include = "meshroom"}]

    [tool.poetry.dependencies]
    python = "^3.7"
    psutil = "^5.9"
    PySide2 = "^5.11"

    [tool.poetry.scripts]
    meshroom = 'meshroom.ui.__main__:main'

    [build-system]
    requires = ["poetry-core"]
    build-backend = "poetry.core.masonry.api"
  '';
  #  markdown = "^2.4"


  passAsFile = [ "ppl" ];

  postPatch = ''
    rm setup.py
    cp $pplPath pyproject.toml

    sed -i 's/^/  /' meshroom/ui/__main__.py
    sed -i '1 i\def main():''\n' meshroom/ui/__main__.py
  '';

  makeWrapperArgs = [
    "--set ALICEVISION_ROOT ${alice-vision.dev}"
    "--set MESHROOM_OUTPUT_QML_WARNINGS 1"
    "\${qtWrapperArgs[@]}"
  ];

  nativeBuildInputs = [
    python3.pkgs.poetry-core

    makeWrapper

    wrapQtAppsHook

    qtbase
    qttools
    qtdeclarative
    qtquickcontrols
    qtquickcontrols2
    qtgraphicaleffects
    qt3d
    qtlocation
    qtcharts

    qmlalembic
    qtalicevision
  ];

  propagatedBuildInputs = with python3.pkgs; [
    # cx_Freeze
    pyside2
    psutil
    requests
    markdown2
    qtpy
    pysideShiboken
  ];

  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
  ];

  meta = {
    description = "3D Reconstruction Software";
    homepage = "https://github.com/alicevision/meshroom";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ tmarkus ];
  };
}


