{ lib, fetchFromGitHub, python3, testers, kas }:

python3.pkgs.buildPythonApplication rec {
  pname = "kas";
  version = "4.4";

  src = fetchFromGitHub {
    owner = "siemens";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ws2V16HSGn2zyMmcG601ScHfONSE/DBVO3Gaj8dktf4=";
  };

  propagatedBuildInputs = with python3.pkgs; [ setuptools kconfiglib jsonschema distro pyyaml gitpython ];

  # Tests require network as they try to clone repos
  doCheck = false;
  passthru.tests.version = testers.testVersion {
    package = kas;
    command = "${pname} --version";
  };

  meta = with lib; {
    homepage = "https://github.com/siemens/kas";
    description = "Setup tool for bitbake based projects";
    license = licenses.mit;
    maintainers = with maintainers; [ bachp ];
  };
}
