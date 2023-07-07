{ lib
, fetchFromGitHub
, substituteAll
, python3Packages
, chia
,
}:
python3Packages.buildPythonApplication rec {
  pname = "chia-dev-tools";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qWWLQ+SkoRu5cLytwwrslqsKORy+4ebO8brULEFGaF0=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit chia;
    })
  ];

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
  ];

  meta = with lib; {
    homepage = "https://www.chia.net/";
    description = "Utility for developing in the Chia ecosystem: Chialisp functions, object inspection, RPC client and more";
    license = with licenses; [ asl20 ];
    maintainers = teams.chia.members;
  };
}
