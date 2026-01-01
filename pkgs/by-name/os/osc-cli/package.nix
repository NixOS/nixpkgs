{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "osc-cli";
  version = "1.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "outscale";
    repo = "osc-cli";
    rev = "v${version}";
    hash = "sha256-7WXy+1NHwFvYmyi5xGfWpq/mbVGJ3WkgP5WQd5pvcC0=";
  };

  build-system = [
    python3.pkgs.setuptools
  ];

  pythonRelaxDeps = [
    "defusedxml"
  ];

  dependencies = with python3.pkgs; [
    defusedxml
    fire
    requests
    typing-extensions
    xmltodict
  ];

  # Skipping tests as they require working access and secret keys
  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "Official Outscale CLI providing connectors to Outscale API";
    homepage = "https://github.com/outscale/osc-cli";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nicolas-goudry ];
=======
  meta = with lib; {
    description = "Official Outscale CLI providing connectors to Outscale API";
    homepage = "https://github.com/outscale/osc-cli";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nicolas-goudry ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "osc-cli";
  };
}
