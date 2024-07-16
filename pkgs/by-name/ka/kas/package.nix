{ lib, fetchFromGitHub, python3, versionCheckHook }:

python3.pkgs.buildPythonApplication rec {
  pname = "kas";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "siemens";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-NjNPcCqmjFeydTgNdN8QRrFG5Mys2jL4I8TiznO2rSA=";
  };

  propagatedBuildInputs = with python3.pkgs; [ setuptools kconfiglib jsonschema distro pyyaml ];

  # Tests require network as they try to clone repos
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/siemens/kas";
    description = "Setup tool for bitbake based projects";
    license = licenses.mit;
    maintainers = with maintainers; [ bachp ];
  };
}
