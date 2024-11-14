{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "kernel-hardening-checker";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "a13xp0p0v";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xpVazB9G0cdc0GglGpna80EWHZXfTd5mc5mTvvvoPfE=";
  };

  meta = with lib; {
    description = "Tool for checking the security hardening options of the Linux kernel";
    homepage = "https://github.com/a13xp0p0v/kernel-hardening-checker";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ erdnaxe ];
    mainProgram = "kernel-hardening-checker";
  };
}
