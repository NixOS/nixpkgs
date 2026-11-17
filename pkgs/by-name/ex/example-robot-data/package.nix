{
  fetchFromGitHub,
  lib,
  jrl-cmakemodules,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "example-robot-data";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "Gepetto";
    repo = "example-robot-data";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oQk6mJ1lOTcWrTWLViVQWk+R6DdcnLSigxKuXgpLhs0=";
  };

  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs;

  buildInputs = [
    jrl-cmakemodules
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [ (lib.cmakeBool "BUILD_PYTHON_INTERFACE" false) ];

  doCheck = true;

  meta = {
    description = "Set of robot URDFs for benchmarking and developed examples";
    homepage = "https://github.com/Gepetto/example-robot-data";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      nim65s
      wegank
    ];
    platforms = lib.platforms.unix;
  };
})
