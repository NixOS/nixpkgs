{
  lib,
  stdenv,
  fetchFromGitHub,
  swig,
  # If we build the python packages, these two are not null
  buildPythonPackage ? null,
  lgpioWithoutPython ? null,
  # When building a python Packages, this specifies the python subproject - a
  # folder in the repository. The current options are:
  #
  # - <empty>
  # - PY_LGPIO
  # - PY_RGPIO
  #
  # Where an empty value means 'build the non python project'.
  pyProject ? "",
}:

let
  mkDerivation = if pyProject == "" then stdenv.mkDerivation else buildPythonPackage;
in
mkDerivation rec {
  pname = "lgpio";
  version = "0.2.2";
  format = if pyProject == "" then null else "setuptools";

  src = fetchFromGitHub {
    owner = "joan2937";
    repo = "lg";
    tag = "v${version}";
    hash = "sha256-92lLV+EMuJj4Ul89KIFHkpPxVMr/VvKGEocYSW2tFiE=";
  };

  nativeBuildInputs = lib.optionals (pyProject == "PY_LGPIO") [
    swig
  ];

  preConfigure = lib.optionalString (pyProject != "") ''
    cd ${pyProject}
  '';
  # Emulate ldconfig when building the C API
  postConfigure = lib.optionalString (pyProject == "") ''
    substituteInPlace Makefile \
      --replace ldconfig 'echo ldconfig'
  '';

  preBuild = lib.optionalString (pyProject == "PY_LGPIO") ''
    swig -python lgpio.i
  '';

  buildInputs = [
    lgpioWithoutPython
  ];

  makeFlags = [
    "prefix=$(out)"
  ];

  meta = {
    description = "Linux C libraries and Python modules for manipulating GPIO";
    homepage = "https://github.com/joan2937/lg";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ doronbehar ];
    platforms = lib.platforms.linux;
  };
}
