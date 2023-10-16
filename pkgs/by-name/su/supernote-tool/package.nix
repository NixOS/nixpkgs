{ lib
, fetchFromGitHub
, python3
}:

let
  pname = "supernote-tool";
  version = "0.4.3";
in
python3.pkgs.buildPythonApplication {
  inherit pname version;
  format = "pyproject";
  disabled = python3.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jya-dev";
    repo = "supernote-tool";
    rev = "v${version}";
    hash = "sha256-mtFkxur61sXEbwu/erKAOzxSkQM8jJXlKvE49W976do=";
  };

  nativeBuildInputs = with python3.pkgs; [ setuptools hatchling ];
  propagatedBuildInputs = with python3.pkgs; [
    colour
    pillow
    potracer
    pypng
    svglib
    svgwrite
  ];

  meta = with lib; {
    description = "Unofficial python tool for Supernote";
    license = licenses.asl20;
    homepage = "https://github.com/jya-dev/supernote-tool";
    maintainers = with maintainers; [ jfvillablanca ];
    mainProgram = "supernote-tool";
    platforms = platforms.all;
  };
}
