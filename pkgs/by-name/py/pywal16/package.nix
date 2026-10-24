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
  writableTmpDirAsHomeHook,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "pywal16";
  version = "3.8.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eylles";
    repo = "pywal16";
    tag = "${finalAttrs.version}";
    hash = "sha256-2KlVeOrF/nfRZk12gthDJ08xNvVbP5em3eXPMudo1Vs=";
  };

  build-system = [ python3.pkgs.setuptools ];

  nativeBuildInputs = [ installShellFiles ];

  dependencies =
    lib.optionals withColorthief finalAttrs.passthru.optional-dependencies.colorthief
    ++ lib.optionals withColorz finalAttrs.passthru.optional-dependencies.colorz
    ++ lib.optionals withFastColorthief finalAttrs.passthru.optional-dependencies.fast-colorthief
    ++ lib.optionals withHaishoku finalAttrs.passthru.optional-dependencies.haishoku
    ++ lib.optionals withModernColorthief finalAttrs.passthru.optional-dependencies.modern_colorthief;

  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
    imagemagick
    writableTmpDirAsHomeHook
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${lib.makeBinPath ([ imagemagick ] ++ lib.optional withColorz colorz)}"
  ];

  postInstall = ''
    installManPage data/man/man1/wal.1
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
    changelog = "https://github.com/eylles/pywal16/blob/refs/tags/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "wal";
  };
})
