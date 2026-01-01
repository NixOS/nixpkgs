{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "commix";
<<<<<<< HEAD
  version = "4.1";
=======
  version = "4.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "commixproject";
    repo = "commix";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-X2AJIE/Uk6w5bcgCELfmy9+Nzoma96yBva9Aj+sKE3k=";
=======
    hash = "sha256-AikhXMacsJ7AZyKWcmu+ngs9KeiwQE60cpM2CV8ej1Y=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
