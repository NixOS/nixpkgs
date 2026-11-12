{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  glpk,
  gmp,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "4ti2";
  version = "1.6.16";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "4ti2";
    repo = "4ti2";
    tag = "Release_${builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-faZdU/4QSTuKFDI3TQWF1LtYGQZAiSEPkg+ahvq+gts=";
  };

  postPatch = ''
    substituteInPlace src/{groebner/script.template.in,zsolve/{graver,hilbert}.template} \
      --replace-fail 'SCRIPT=$(realpath $(which "$0"))' \
                     'SCRIPT=$(realpath $(${lib.getExe which} "$0"))'
  ''
  + lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # configure.ac tries to compile and execute a specific test file here
    substituteInPlace configure.ac \
      --replace-fail "CHECK_TRAPV" ""
  '';

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    glpk
    gmp
  ];

  enableParallelBuilding = true;
  enableParallelInstalling = false;

  installFlags = [ "install-exec" ];

  meta = {
    homepage = "https://4ti2.github.io/";
    description = "Software package for algebraic, geometric and combinatorial problems on linear spaces";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ coolcuber ];
    platforms = lib.platforms.all;
  };
})
