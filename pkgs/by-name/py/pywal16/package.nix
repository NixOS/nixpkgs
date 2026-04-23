{
  lib,
  python3,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,

  imagemagick,
  colorz,

  withColorthief ? false,
  withColorz ? false,
  withFastColorthief ? false,
  withHaishoku ? false,
  withModernColorthief ? false,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pywal16";
  version = "3.8.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eylles";
    repo = "pywal16";
    tag = version;
    hash = "sha256-68HbYH4wydaM1yY8kGHNIHTOZuUQRl+9o5ZPaemTlUE=";
  };

  build-system = [ python3.pkgs.setuptools ];

  nativeBuildInputs = [ installShellFiles ];

  dependencies =
    lib.optionals withColorthief optional-dependencies.colorthief
    ++ lib.optionals withColorz optional-dependencies.colorz
    ++ lib.optionals withFastColorthief optional-dependencies.fast-colorthief
    ++ lib.optionals withHaishoku optional-dependencies.haishoku
    ++ lib.optionals withModernColorthief optional-dependencies.modern_colorthief;

  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
    imagemagick
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath ([ imagemagick ] ++ lib.optional withColorz colorz)}"
  ];

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
    modern_colorthief = [ modern-colorthief ];
    all = [
      colorthief
      colorz
      fast-colorthief
      haishoku
      modern-colorthief
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
