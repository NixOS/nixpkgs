{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gitxray";
<<<<<<< HEAD
  version = "1.0.19";
=======
  version = "1.0.18";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kulkansecurity";
    repo = "gitxray";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-jdN91oiKMr8ozjsQG2+lI55nPbjBa+ipWG9GYeFXCDw=";
=======
    hash = "sha256-d8NHRcCPTW935lb5MNkmxc8lhyByU0X+iKTUwY8ycRo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [ requests ];

  pythonImportsCheck = [ "gitxray" ];

  meta = {
    description = "Tool which leverages Public GitHub REST APIs for various tasks";
    homepage = "https://github.com/kulkansecurity/gitxray";
    changelog = "https://github.com/kulkansecurity/gitxray/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "gitxray";
  };
}
