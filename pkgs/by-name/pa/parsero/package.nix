{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication {
  pname = "parsero";
  version = "0.81";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "behindthefirewalls";
    repo = "parsero";
    rev = "e5b585a19b79426975a825cafa4cc8a353cd267e";
    sha256 = "rqupeJxslL3AfQ+CzBWRb4ZS32VoYd8hlA+eACMKGPY=";
  };

  build-system = with python3Packages; [ setuptools ];

  pythonRemoveDeps = [
    "pip" # this dependency is never actually used
  ];

  dependencies = with python3Packages; [
    beautifulsoup4
    urllib3
  ];

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "Robots.txt audit tool";
    homepage = "https://github.com/behindthefirewalls/Parsero";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      emilytrau
      fab
    ];
    mainProgram = "parsero";
  };
}
