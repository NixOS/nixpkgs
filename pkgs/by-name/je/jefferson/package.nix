{
  lib,
  fetchFromGitHub,
  gitUpdater,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "jefferson";
  version = "0.4.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "onekey-sec";
    repo = "jefferson";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/YZ3JvXtnjwGipZ3WlJbeUdn4cDhVoHETsrkIHHADM8=";
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
