{
  lib,
  fetchFromGitHub,
  python3Packages,
  expect,
}:

python3Packages.buildPythonApplication {
  pname = "exe2hex";
  version = "1.5.2-unstable-2020-04-27";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "g0tmi1k";
    repo = "exe2hex";
    rev = "e563b353306a0f34d96150b8992f543931f907ea";
    hash = "sha256-wriB1k45QWNCIsSb30Z3IilTGZqnc+X1+qkRrxgDxzU=";
  };

  propagatedBuildInputs = [
    expect
  ];

  postPatch = ''
    substituteInPlace exe2hex.py \
      --replace-fail "/usr/bin/expect" "${lib.getExe expect}"
  '';

  postInstall = ''
    install -Dm 555 exe2hex.py $out/bin/exe2hex
  '';

  meta = with lib; {
    description = "Inline file transfer using in-built Windows tools";
    homepage = "https://github.com/g0tmi1k/exe2hex";
    mainProgram = "exe2hex";
    license = licenses.mit;
    maintainers = with maintainers; [ d3vil0p3r ];
  };
}
