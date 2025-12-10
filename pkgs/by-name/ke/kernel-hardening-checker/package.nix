{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "kernel-hardening-checker";
  version = "0.6.10.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "a13xp0p0v";
    repo = "kernel-hardening-checker";
    rev = "v${version}";
    hash = "sha256-9FhDDKTx/YwlEuGf7fgugC5tPgslzXZdlXCCfuM09Dg=";
  };

  build-system = with python3Packages; [ setuptools ];

  pythonImportsCheck = [ "kernel_hardening_checker" ];

  meta = {
    description = "Tool for checking the security hardening options of the Linux kernel";
    homepage = "https://github.com/a13xp0p0v/kernel-hardening-checker";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ erdnaxe ];
    mainProgram = "kernel-hardening-checker";
  };
}
