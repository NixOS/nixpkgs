{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "commix";
  version = "4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "commixproject";
    repo = "commix";
    tag = "v${version}";
    hash = "sha256-AikhXMacsJ7AZyKWcmu+ngs9KeiwQE60cpM2CV8ej1Y=";
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

  meta = {
    description = "Automated Command Injection Exploitation Tool";
    mainProgram = "commix";
    homepage = "https://github.com/commixproject/commix";
    changelog = "https://github.com/commixproject/commix/releases/tag/v${version}";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
