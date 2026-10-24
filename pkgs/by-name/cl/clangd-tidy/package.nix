{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "clangd-tidy";
  version = "1.1.0.post2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lljbash";
    repo = "clangd-tidy";
    rev = "v${version}";
    hash = "sha256-ozFJVZhOl/h7BAyp7abHd+VDFRZ8R+cN3j/sEcoIfjk=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.setuptools-scm
  ];

  dependencies = [
    python3.pkgs.attrs
    python3.pkgs.cattrs
    python3.pkgs.tqdm
    python3.pkgs.typing-extensions
  ];

  pythonImportsCheck = [
    "clangd_tidy"
  ];

  meta = {
    description = "A faster alternative to clang-tidy";
    homepage = "https://github.com/lljbash/clangd-tidy";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "clangd-tidy";
  };
}
