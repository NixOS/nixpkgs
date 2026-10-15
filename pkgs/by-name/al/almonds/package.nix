{
  lib,
  python3,
  fetchFromGitHub,
  ncurses,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "almonds";
  version = "1.25b";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Tenchi2xh";
    repo = "Almonds";
    tag = finalAttrs.version;
    hash = "sha256-mo8sj2aFaYAaPa9t8J0tA8Mi8dKGE3Yp6s7u+KNEDUk=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [ pillow ];

  buildInputs = [ ncurses ];

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  meta = {
    description = "Terminal Mandelbrot fractal viewer";
    mainProgram = "almonds";
    homepage = "https://github.com/Tenchi2xh/Almonds";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
