{ lib
, stdenv
, fetchFromGitHub
, python3Packages
}:

let
  version = "4.5.1";
in
python3Packages.buildPythonPackage {
  pname = "klocalizer";
  inherit version;

  src = fetchFromGitHub {
    owner = "paulgazz";
    repo = "kmax";
    inherit version;
    rev = "v${version}";
    hash = "sha256-fNs/i8kjc3P6XvX5lvSvNLfhoetr0plNVG+KcRD/Otc=";
  };

  # complains cryptically about wanting `--use-pep517`
  doCheck = false;

  propagatedBuildInputs = with python3Packages; [
    packaging
    z3
    setuptools
    regex
    whatthepatch
    requests
  ];

  meta = {
    description = "Linux Kconfig constraint SAT/SMT solver";
    license = [ lib.licenses.gpl2 ];
    mainProgram = "klocalizer";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    homepage = "https://github.com/paulgazz/kmax";
  };
}
