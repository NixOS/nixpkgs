{
  lib,
  stdenv,
  fetchFromGitHub,
  git,
  m4,
  tcl,
  tk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "irsim";
  version = "9.7.119";

  src = fetchFromGitHub {
    owner = "RTimothyEdwards";
    repo = "irsim";
    tag = "${finalAttrs.version}";
    hash = "sha256-XtmSxZfMknx13KXVo5pHPGIOUWU0x3AH608+6qVYqlQ=";
  };

  nativeBuildInputs = [
    git
  ];

  buildInputs = [
    m4
    tcl
    tk
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-tcl=${tcl}"
    "--with-tk=${tk}"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration -Wno-implicit-int";

  meta = {
    description = "VLSI switch-level simulator";
    homepage = "http://opencircuitdesign.com/irsim/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ dezash ];
  };
})
