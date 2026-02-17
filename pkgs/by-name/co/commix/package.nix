{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "commix";
  version = "4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "commixproject";
    repo = "commix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X2AJIE/Uk6w5bcgCELfmy9+Nzoma96yBva9Aj+sKE3k=";
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
    changelog = "https://github.com/commixproject/commix/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
