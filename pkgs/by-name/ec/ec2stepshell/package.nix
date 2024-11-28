{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ec2stepshell";
  version = "unstable-2023-04-07";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "saw-your-packet";
    repo = "EC2StepShell";
    rev = "ab1298fa7f2650de711e86e870a693dcce0e1935";
    hash = "sha256-zy33CgGwa2pBYouqaJ1LM6uRIh3Q1uxi2zNXpDNPsuQ=";
  };

  postPatch = ''
    # https://github.com/saw-your-packet/EC2StepShell/pull/1
    substituteInPlace pyproject.toml \
      --replace "realpython" "ec2stepshell"
  '';

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    boto3
    colorama
    pyfiglet
    termcolor
  ];

  pythonImportsCheck = [
    "ec2stepshell"
  ];

  meta = with lib; {
    description = "AWS post-exploitation tool";
    mainProgram = "ec2stepshell";
    homepage = "https://github.com/saw-your-packet/EC2StepShell";
    changelog = "https://github.com/saw-your-packet/EC2StepShell/blob/${version}/CHANGELOG.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
