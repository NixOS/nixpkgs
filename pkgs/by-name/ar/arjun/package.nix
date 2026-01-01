{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "arjun";
<<<<<<< HEAD
  version = "2.2.7-unstable-2025-02-20";
=======
  version = "2.2.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "s0md3v";
    repo = "Arjun";
<<<<<<< HEAD
    rev = "d1fb995cb1e064d4e171d83f19f6af79b0a3c5ce";
    hash = "sha256-z6YGCwypp69+98KSC1YUzJETfwb3V4Qp1sV5V3N9zMI=";
=======
    tag = version;
    hash = "sha256-XEfCQEvRCvmNQ8yOlaR0nd7knhK1fQIrXEfQgrdVDrs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
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
<<<<<<< HEAD
    changelog = "https://github.com/s0md3v/Arjun/blob/${src.rev}/CHANGELOG.md";
=======
    changelog = "https://github.com/s0md3v/Arjun/blob/${version}/CHANGELOG.md";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ octodi ];
    mainProgram = "arjun";
  };
}
