{
  lib,
  python3,
  fetchFromGitHub,
<<<<<<< HEAD
  installShellFiles,
  nix-update-script,

  imagemagick,
  colorz,

  withColorthief ? false,
  withColorz ? false,
  withFastColorthief ? false,
  withHaishoku ? false,
  withModernColorthief ? false,
=======
  imagemagick,
  installShellFiles,
  nix-update-script,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pywal16";
<<<<<<< HEAD
  version = "3.8.13";
=======
  version = "3.8.11";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eylles";
    repo = "pywal16";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-BKLvEmasMTcuH5olgZHzFN3DZT4lXD1FNBU8l8QGQAM=";
=======
    hash = "sha256-BZd8ditvcLLJDCWaWtSEUkOBgLM2LvtX5UbKOMz7eno=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ python3.pkgs.setuptools ];

  nativeBuildInputs = [ installShellFiles ];

<<<<<<< HEAD
  dependencies =
    lib.optionals withColorthief optional-dependencies.colorthief
    ++ lib.optionals withColorz optional-dependencies.colorz
    ++ lib.optionals withFastColorthief optional-dependencies.fast-colorthief
    ++ lib.optionals withHaishoku optional-dependencies.haishoku
    ++ lib.optionals withModernColorthief optional-dependencies.modern_colorthief;

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
    imagemagick
  ];

<<<<<<< HEAD
  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath ([ imagemagick ] ++ lib.optional withColorz colorz)}"
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  postInstall = ''
    installManPage data/man/man1/wal.1
  '';

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "pywal" ];

  optional-dependencies = with python3.pkgs; {
    colorthief = [ colorthief ];
    colorz = [ colorz ];
    fast-colorthief = [ fast-colorthief ];
    haishoku = [ haishoku ];
<<<<<<< HEAD
    modern_colorthief = [ modern-colorthief ];
    all = [
      colorthief
      colorz
      fast-colorthief
      haishoku
      modern-colorthief
=======
    all = [
      colorthief
      colorz
      ast-colorthief
      haishoku
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ];
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "16 colors fork of pywal";
    homepage = "https://github.com/eylles/pywal16";
    changelog = "https://github.com/eylles/pywal16/blob/refs/tags/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "wal";
  };
}
