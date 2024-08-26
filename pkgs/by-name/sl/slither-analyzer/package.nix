{
  slither-analyzer,
  lib,
  makeWrapper,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
  solc,
  withSolc ? false,
  testers
}:

python3Packages.buildPythonApplication rec {
  pname = "slither-analyzer";
  version = "0.10.3";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "slither";
    rev = "refs/tags/${version}";
    hash = "sha256-KWLv0tpd1FHZ9apipVPWw6VjtfYpngsH7XDQQ3luBZA=";
  };

  nativeBuildInputs = [
    makeWrapper
    python3Packages.setuptools-scm
  ];

  propagatedBuildInputs = with python3Packages; [
    crytic-compile
    web3
    packaging
    prettytable
  ];

  postFixup = lib.optionalString withSolc ''
    wrapProgram $out/bin/slither \
      --prefix PATH : "${lib.makeBinPath [ solc ]}"
  '';

  # required for pythonImportsCheck
  postInstall = ''
    export HOME="$TEMP"
  '';

  pythonImportsCheck = [
    "slither"
    "slither.all_exceptions"
    "slither.analyses"
    "slither.core"
    "slither.detectors"
    "slither.exceptions"
    "slither.formatters"
    "slither.printers"
    "slither.slither"
    "slither.slithir"
    "slither.solc_parsing"
    "slither.utils"
    "slither.visitors"
    "slither.vyper_parsing"
  ];

  # Test if the binary works during the build phase.
  checkPhase = ''
    runHook preCheck

    HOME="$TEMP" $out/bin/slither --version

    runHook postCheck
  '';

  passthru.tests.version = testers.testVersion {
    package = slither-analyzer;
    command = "HOME=$TMPDIR slither --version";
    version = "${version}";
  };

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Static Analyzer for Solidity";
    longDescription = ''
      Slither is a Solidity static analysis framework written in Python 3. It
      runs a suite of vulnerability detectors, prints visual information about
      contract details, and provides an API to easily write custom analyses.
    '';
    homepage = "https://github.com/trailofbits/slither";
    changelog = "https://github.com/crytic/slither/releases/tag/${version}";
    license = licenses.agpl3Plus;
    mainProgram = "slither";
    maintainers = with maintainers; [
      arturcygan
      fab
      hellwolf
    ];
  };
}
