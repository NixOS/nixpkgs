{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "arjun";
  version = "2.2.7-unstable-2025-02-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "s0md3v";
    repo = "Arjun";
    rev = "d1fb995cb1e064d4e171d83f19f6af79b0a3c5ce";
    hash = "sha256-z6YGCwypp69+98KSC1YUzJETfwb3V4Qp1sV5V3N9zMI=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    dicttoxml
    ratelimit
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "arjun" ];

  meta = {
    description = "HTTP parameter discovery suite";
    homepage = "https://github.com/s0md3v/Arjun";
    changelog = "https://github.com/s0md3v/Arjun/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ octodi ];
    mainProgram = "arjun";
  };
})
