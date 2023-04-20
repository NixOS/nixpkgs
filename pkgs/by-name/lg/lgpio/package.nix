{
  lib,
  stdenv,
  fetchFromGitHub,
  swig,
  # If we build the python packages, these two not null
  buildPythonPackage ? null,
  lgpioWithoutPython ? null,
  # When building a python Packages, this specifies the python subproject
  pyProject ? "",
}:

let
  mkDerivation = if pyProject == "" then stdenv.mkDerivation else buildPythonPackage;
  preConfigure =
    if pyProject != "" then
      ''
        cd ${pyProject}
      ''
    else
      '''';
  # Emulate ldconfig when building the C API
  postConfigure =
    if pyProject == "" then
      ''
        substituteInPlace Makefile \
          --replace ldconfig 'echo ldconfig'
      ''
    else
      '''';
  preBuild =
    if pyProject == "PY_LGPIO" then
      ''
        swig -python lgpio.i
      ''
    else
      '''';
in
mkDerivation rec {
  pname = "lgpio";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "joan2937";
    repo = "lg";
    rev = "v${version}";
    hash = "sha256-92lLV+EMuJj4Ul89KIFHkpPxVMr/VvKGEocYSW2tFiE=";
  };
  nativeBuildInputs = lib.optionals (pyProject == "PY_LGPIO") [ swig ];
  buildInputs = [ lgpioWithoutPython ];
  inherit preConfigure postConfigure preBuild;
  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    description = "Linux C libraries and Python modules for manipulating GPIO";
    homepage = "https://github.com/joan2937/lg";
    license = with licenses; [ unlicense ];
    maintainers = with maintainers; [ doronbehar ];
  };
}
