{
  lib,
  fetchFromGitHub,
  gitUpdater,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "jefferson";
  version = "0.4.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "onekey-sec";
    repo = "jefferson";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6eh4i9N3aArU8+W8K341pp9J0QYEojDiMrEc8yax4SY=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    cstruct
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
