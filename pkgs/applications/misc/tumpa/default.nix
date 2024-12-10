{
  lib,
  python3,
  fetchFromGitHub,
  wrapQtAppsHook,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "tumpa";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "kushaldas";
    repo = "tumpa";
    rev = "v${version}";
    hash = "sha256-sT+IasupBxkfYoOULRvG429ZHA94uAJoYfFd1Whs0J4=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    johnnycanencrypt
    pyside2
  ];

  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  dontWrapQtApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  doCheck = false;

  meta = with lib; {
    description = "OpenPGP key creation and smartcard access";
    homepage = "https://github.com/kushaldas/tumpa";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ _0x4A6F ];
    broken = true;
  };
}
