{
  lib,
  python3,
  fetchFromGitHub,
  imagemagick,
  installShellFiles,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pywal16";
  version = "3.8.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eylles";
    repo = "pywal16";
    tag = version;
    hash = "sha256-OSWv6Pxmd5U1xydL45dVT6m7gu4Rx6Yln3R4dTFZoVE=";
  };

  build-system = [ python3.pkgs.setuptools ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
    imagemagick
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
    all = [
      colorthief
      colorz
      ast-colorthief
      haishoku
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
