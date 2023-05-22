{ lib
, fetchFromGitHub
, python3Packages
, chia
,
}:
python3Packages.buildPythonApplication rec {
  pname = "chia-dev-tools";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dfndXkThb+p5cAD30Wno753txI2cPIK4Jp+AMmQBLhk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "==" ">="
  '';

  nativeBuildInputs = [
    python3Packages.setuptools-scm
  ];

  # give a hint to setuptools-scm on package version
  SETUPTOOLS_SCM_PRETEND_VERSION = "v${version}";

  propagatedBuildInputs = with python3Packages; [
    anyio
    (toPythonModule chia)
    pytest # required at runtime by the "test" command
    pytest-asyncio
    pytimeparse
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';
  postCheck = "unset HOME";

  disabledTests = [
    "test_spendbundles"
    "test_spends"
  ];

  meta = with lib; {
    homepage = "https://www.chia.net/";
    description = "Utility for developing in the Chia ecosystem: Chialisp functions, object inspection, RPC client and more";
    license = with licenses; [ asl20 ];
    maintainers = teams.chia.members;
  };
}
