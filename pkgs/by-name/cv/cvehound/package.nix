{
  lib,
  fetchFromGitHub,
  coccinelle,
  gnugrep,
  python3,
}:
let
  runtimeDeps = [
    coccinelle
    gnugrep
  ];
in
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "cvehound";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "evdenis";
    repo = "cvehound";
    tag = finalAttrs.version;
    hash = "sha256-UvjmlAm/8B4KfE9grvvgn37Rui+ZRfs2oTLqYYgqcUQ=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    lxml
    sympy
  ];

  nativeCheckInputs = with python3.pkgs; [
    gitpython
    psutil
    pytestCheckHook
  ];

  # Tries to clone the kernel sources
  doCheck = false;

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath finalAttrs.passthru.runtimeDeps)
  ];

  passthru = {
    inherit runtimeDeps;
  };

  meta = {
    description = "Tool to check linux kernel source dump for known CVEs";
    homepage = "https://github.com/evdenis/cvehound";
    changelog = "https://github.com/evdenis/cvehound/blob/${finalAttrs.src.rev}/ChangeLog";
    # See https://github.com/evdenis/cvehound/issues/22
    license = with lib.licenses; [
      gpl2Only
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})
