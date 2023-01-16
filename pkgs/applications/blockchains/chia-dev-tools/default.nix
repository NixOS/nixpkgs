{ lib
, fetchFromGitHub
, substituteAll
, python3Packages
, chia
,
}:
python3Packages.buildPythonApplication rec {
  pname = "chia-dev-tools";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-lE7FTSDqVS6AstcxZSMdQwgygMvcvh1fqYVTTSSNZpA=";
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
    (toPythonModule chia)
    pytimeparse
  ];

  checkInputs = with python3Packages; [
    pytestCheckHook
    pytest-asyncio
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
