{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "above";
  version = "2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "casterbyte";
    repo = "Above";
    rev = "refs/tags/v${version}";
    hash = "sha256-tOSAci9aIALNCL3nLui96EdvqjNxnnuj2/dMdWLY9yI=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    colorama
    scapy
  ];

  postFixup = ''
    mv $out/bin/above.py $out/bin/$pname
  '';

  # Project has no tests
  doCheck = false;

  meta = {
    description = "Invisible network protocol sniffer";
    homepage = "https://github.com/casterbyte/Above";
    changelog = "https://github.com/casterbyte/Above/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "above";
  };
}
