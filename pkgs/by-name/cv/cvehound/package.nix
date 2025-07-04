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
  format = "setuptools";

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

  propagatedBuildInputs = with python3.pkgs; [
    lxml
    setuptools
    sympy
  ];

  nativeCheckInputs = with python3.pkgs; [
    gitpython
    psutil
    pytestCheckHook
  ];

  # Tries to clone the kernel sources
  doCheck = false;

  meta = with lib; {
    description = "Tool to check linux kernel source dump for known CVEs";
    homepage = "https://github.com/evdenis/cvehound";
    changelog = "https://github.com/evdenis/cvehound/blob/${src.rev}/ChangeLog";
    # See https://github.com/evdenis/cvehound/issues/22
    license = with licenses; [
      gpl2Only
      gpl3Plus
    ];
    maintainers = with maintainers; [ ambroisie ];
  };
}
