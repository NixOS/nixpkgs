{
  lib,
  python3,
  fetchFromGitHub,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  __structuredAttrs = true;

  pname = "stui";
  version = "0.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mil-ad";
    repo = "stui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-shdQcjPs65fFdbCQG/nhKgXhHzrFrqHflrq0RmknR20=";
  };

  build-system = [
    python3.pkgs.setuptools
  ];

  dependencies = [
    python3.pkgs.urwid
    python3.pkgs.fabric
  ];

  pythonImportsCheck = [
    "stui"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A Slurm dashboard for the terminal";
    homepage = "https://github.com/mil-ad/stui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nemeott ];
    mainProgram = "stui";
  };
})
