{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "kernel-hardening-checker";
<<<<<<< HEAD
  version = "0.6.17.1";
=======
  version = "0.6.10.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "a13xp0p0v";
    repo = "kernel-hardening-checker";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-wkRbiXHLtTDYBrxn9ZPxXMmWJiIBI5AImjFo6NVaKRM=";
=======
    hash = "sha256-9FhDDKTx/YwlEuGf7fgugC5tPgslzXZdlXCCfuM09Dg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = with python3Packages; [ setuptools ];

  pythonImportsCheck = [ "kernel_hardening_checker" ];

<<<<<<< HEAD
  meta = {
    description = "Tool for checking the security hardening options of the Linux kernel";
    homepage = "https://github.com/a13xp0p0v/kernel-hardening-checker";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ erdnaxe ];
=======
  meta = with lib; {
    description = "Tool for checking the security hardening options of the Linux kernel";
    homepage = "https://github.com/a13xp0p0v/kernel-hardening-checker";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ erdnaxe ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "kernel-hardening-checker";
  };
}
