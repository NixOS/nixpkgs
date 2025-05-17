{
  fetchFromGitLab,
  python312Packages,
  python312,
  python3,
  tor,
  lib,
  symlinkJoin,
}:

let
  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    owner = "tpo";
    repo = "onion-services/onionbalance";
    rev = "2de68025d2ba786936cc9dad67b62360e0a1294b";
    sha256 = "sha256-Fn62GtA62kkjqHsMmDLIenM5+mxVcVUSS32ADUYGND4=";
  };

  onionbalance = python312Packages.buildPythonPackage rec {
    inherit src;
    pname = "onionbalance";
    version = "0.2.3";
    doCheck = false;
    format = "pyproject";
    dontCheckRuntimeDeps = true;
    buildInputs = [ tor ];
    propagatedBuildInputs = [
with python312Packages;
          cryptography
          pycryptodomex
          pyyaml
          setproctitle
          setuptools
          stem
        ]
      ))
    ];

    meta = {
      description = "Load balancing for onion services";
      homepage = "https://gitlab.torproject.org/tpo/onion-services/onionbalance";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ MulliganSecurity ];
      mainProgram = "onionbalance";
      changelog = "https://gitlab.torproject.org/tpo/onion-services/onionbalance/-/tags/${version}";
    };

  };
  onionbalance-config = python312Packages.buildPythonPackage rec {
    inherit src;
    pname = "onionbalance-config";
    version = "0.2.3";
    doCheck = false;
    pyproject = true;
    dontCheckRuntimeDeps = true;
    buildInputs = [ tor ];
    dependencies = with python312Packages; [
          cryptography
          pycryptodomex
          pyyaml
          setproctitle
          setuptools
          stem
        ]
      ))
    ];

    meta = {
      description = "Onionbalance config generator";
      homepage = "https://gitlab.torproject.org/tpo/onion-services/onionbalance";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ MulliganSecurity ];
      platforms = lib.platforms.linux;
      mainProgram = "onionbalance-config";
    };

  };

in
symlinkJoin {
  name = "onionbalance";
  paths = [
    onionbalance
    onionbalance-config
  ];
}
