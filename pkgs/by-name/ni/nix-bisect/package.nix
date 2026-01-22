{
  lib,
  fetchFromGitHub,
  python3,
}:

let
  pname = "nix-bisect";
  version = "0.4.2";
in
python3.pkgs.buildPythonApplication {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KiaraGrouwstra";
    repo = "nix-bisect";
    tag = "v${version}";
    hash = "sha256-JHywmX6Bp24OXCDRYuM0PEgVNPFRwYsge198u9e+lQs=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    appdirs
    numpy
    pexpect
  ];

  doCheck = false;

  pythonImportsCheck = [ "nix_bisect" ];

  meta = {
    description = "Bisect nix builds";
    homepage = "https://github.com/KiaraGrouwstra/nix-bisect";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kiara ];
  };
}
