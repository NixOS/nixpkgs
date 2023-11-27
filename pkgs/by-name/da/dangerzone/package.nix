{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dangerzone";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "freedomofpress";
    repo = "dangerzone";
    rev = "v${version}";
    hash = "sha256-t1KgdK5RsMu08cIEijJ5aag1dYMwlAXBQffo9SfS/Ss=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    click
    colorama
    markdown
    packaging
    pyside6
    pyxdg
    requests
  ];

  patches = [
    # patch resource path to look in $out instead of the python library path
    ./patch-resource-path.patch
  ];

  resourcePath = "${placeholder "out"}/share";

  postPatch = ''
    substituteAllInPlace dangerzone/util.py
  '';

  postInstall = ''
    cp -r $src/share $out/
  '';

  pythonImportsCheck = [ "dangerzone" ];

  meta = {
    description = "Take potentially dangerous PDFs, office documents, or images and convert them to safe PDFs";
    homepage = "https://github.com/freedomofpress/dangerzone";
    changelog = "https://github.com/freedomofpress/dangerzone/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eclairevoyant ];
    mainProgram = "dangerzone";
  };
}
