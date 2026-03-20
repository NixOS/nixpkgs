{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pyrosimple,
  python3,
  testers,
  withInotify ? stdenv.hostPlatform.isLinux,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "pyrosimple";
  version = "2.14.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kannibalox";
    repo = "pyrosimple";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qER73B6wuRczwV23A+NwfDL4oymvSwmauA0uf2AE+kY=";
  };

  pythonRelaxDeps = [
    "prometheus-client"
    "python-daemon"
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs =
    with python3.pkgs;
    [
      bencode-py
      apscheduler
      jinja2
      python-daemon
      importlib-resources
      parsimonious
      prometheus-client
      prompt-toolkit
      requests
      shtab
      python-box
      tomli-w
    ]
    ++ lib.optional withInotify inotify;

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = testers.testVersion {
      package = pyrosimple;
      command = "pyroadmin --version";
    };
  };

  meta = {
    description = "RTorrent client";
    homepage = "https://kannibalox.github.io/pyrosimple/";
    changelog = "https://github.com/kannibalox/pyrosimple/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ vamega ];
  };
})
