{
  lib,
  fetchFromGitHub,
  stdenv,

  pythonSupport ? false,
  python3Packages,

  # buildInputs
  jrl-cmakemodules,

  # checkInputs
  example-robot-data,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-romeo";
  version = "9.0.2";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-romeo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ku75cAlEEOdsAFWv/Xrl0zmQvDYuzPOAfVeO2oHaIc0=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs =
    jrl-cmakemodules.docsNativeBuildInputs ++ lib.optional pythonSupport python3Packages.python;

  buildInputs = [
    jrl-cmakemodules
  ];

  checkInputs = [
    example-robot-data
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python and ros launch files for Romeo robot in hpp";
    homepage = "https://github.com/humanoid-path-planner/hpp_romeo";
    changelog = "https://github.com/humanoid-path-planner/hpp_romeo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
