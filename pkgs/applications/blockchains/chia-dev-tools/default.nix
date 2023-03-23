{ lib
, fetchFromGitHub
, fetchpatch
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
    (fetchpatch {
      url = "https://github.com/Chia-Network/chia-dev-tools/commit/41abe9f2af53b09ca5023daece710eacebd507c7.patch";
      hash = "sha256-mRdg+n1rQoHvWIty+mxXPuLgiqJfl2/UfCOZKVDFOmc=";
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
    "test_spends"
  ];

  meta = with lib; {
    homepage = "https://www.chia.net/";
    description = "Utility for developing in the Chia ecosystem: Chialisp functions, object inspection, RPC client and more";
    license = with licenses; [ asl20 ];
    maintainers = teams.chia.members;
  };
}
