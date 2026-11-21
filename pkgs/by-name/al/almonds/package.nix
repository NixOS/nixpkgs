{
  lib,
  python3Packages,
  fetchFromGitHub,
  ncurses,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "almonds";
  version = "1.25b";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Tenchi2xh";
    repo = "Almonds";
    tag = finalAttrs.version;
    sha256 = "0j8d8jizivnfx8lpc4w6sbqj5hq35nfz0vdg7ld80sc5cs7jr3ws";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [ pillow ];

  buildInputs = [ ncurses ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  meta = {
    description = "Terminal Mandelbrot fractal viewer";
    mainProgram = "almonds";
    homepage = "https://github.com/Tenchi2xh/Almonds";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
