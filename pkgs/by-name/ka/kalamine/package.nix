{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "kalamine";
  version = "0.40";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OneDeadKey";
    repo = "kalamine";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9R8N5p+VNuiqTl3a0SSmJEVg3Ol76nROf43GsdOdJL8=";
  };

  nativeBuildInputs = [
    python3.pkgs.hatchling
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    livereload
    lxml
    progress
    pyyaml
    tomli
  ];

  pythonImportsCheck = [ "kalamine" ];

  meta = {
    description = "Keyboard Layout Maker";
    homepage = "https://github.com/OneDeadKey/kalamine/";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "kalamine";
  };
})
