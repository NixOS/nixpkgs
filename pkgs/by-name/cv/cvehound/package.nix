{
  lib,
  fetchFromGitHub,
  coccinelle,
  gnugrep,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cvehound";
  version = "1.2.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "evdenis";
    repo = "cvehound";
    tag = version;
    hash = "sha256-UvjmlAm/8B4KfE9grvvgn37Rui+ZRfs2oTLqYYgqcUQ=";
  };

  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        coccinelle
        gnugrep
      ]
    }"
  ];

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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Tool to check linux kernel source dump for known CVEs";
    homepage = "https://github.com/evdenis/cvehound";
    changelog = "https://github.com/evdenis/cvehound/blob/${src.rev}/ChangeLog";
    # See https://github.com/evdenis/cvehound/issues/22
<<<<<<< HEAD
    license = with lib.licenses; [
      gpl2Only
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ ambroisie ];
=======
    license = with licenses; [
      gpl2Only
      gpl3Plus
    ];
    maintainers = with maintainers; [ ambroisie ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
