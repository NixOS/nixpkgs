{
  lib,
  fetchFromGitHub,
  gitUpdater,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "jefferson";
  version = "0.4.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "onekey-sec";
    repo = "jefferson";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dIb6ZmjGxDwUO0L6Uy2SlgioY8NCnTO7IGveRraw0LI=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    dissect-cstruct
    lzallright
  ];

  pythonImportsCheck = [
    "jefferson"
  ];

  # upstream has no tests
  doCheck = false;

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "JFFS2 filesystem extraction tool";
    homepage = "https://github.com/onekey-sec/jefferson";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      tnias
      vlaci
    ];
    mainProgram = "jefferson";
  };
})
