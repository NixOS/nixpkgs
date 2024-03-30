{ lib
, stdenv
, fetchFromGitHub
, python3Packages
}:

let
  finalAttrs = {
    pname = "kmax";
    version = "4.5.2";

    src = fetchFromGitHub {
      owner = "paulgazz";
      repo = "kmax";
      rev = "v${finalAttrs.version}";
      hash = "sha256-9LAR+1MdT2YjsPAvmSIdiBTqUh5WYdJuREzLYHRMIMw=";
    };

    build-system = with python3Packages; [
      setuptools
    ];

    dependencies = with python3Packages; [
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
      changelog = "https://github.com/paulgazz/kmax/releases/tag/${finalAttrs.src.rev}";
      license = with lib.licenses; [ gpl2Plus ];
      mainProgram = "kmax";
      maintainers = with lib.maintainers; [ AndersonTorres ];
    };
  };
in
python3Packages.buildPythonPackage finalAttrs
