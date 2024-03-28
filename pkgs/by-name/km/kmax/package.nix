{ lib
, stdenv
, fetchFromGitHub
, python3Packages
}:

let
  pname = "kmax";
  version = "4.5.2";
  src = fetchFromGitHub {
    owner = "paulgazz";
    repo = "kmax";
    rev = "v${version}";
    hash = "sha256-9LAR+1MdT2YjsPAvmSIdiBTqUh5WYdJuREzLYHRMIMw=";
  };
in
python3Packages.buildPythonPackage {
  inherit pname version src;

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    packaging
    regex
    requests
    whatthepatch
    z3-solver
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  meta = {
    homepage = "https://github.com/paulgazz/kmax";
    description = "Linux Kconfig constraint SAT/SMT solver";
    license = with lib.licenses; [ gpl2Plus ];
    mainProgram = "kmax";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
