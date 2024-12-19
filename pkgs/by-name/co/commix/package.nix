{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "commix";
  version = "3.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "commixproject";
    repo = "commix";
    rev = "refs/tags/v${version}";
    hash = "sha256-HX+gEL9nmq9R1GFw8xQaa7kBmW7R0IepitM08bIf3vY=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-warn "-stable" ""
  '';

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  postInstall = ''
    # Helper files are not handled by setup.py
    mkdir -p $out/${python3.sitePackages}/src/txt
    install -vD src/txt/* $out/${python3.sitePackages}/src/txt/
  '';

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "Automated Command Injection Exploitation Tool";
    mainProgram = "commix";
    homepage = "https://github.com/commixproject/commix";
    changelog = "https://github.com/commixproject/commix/releases/tag/v${version}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
