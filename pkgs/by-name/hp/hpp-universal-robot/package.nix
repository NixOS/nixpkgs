{
  lib,
  fetchFromGitHub,
  stdenv,

  pythonSupport ? false,
  python3Packages,

  # buildInputs
  jrl-cmakemodules,

  # propagatedBuildInputs
  example-robot-data,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-universal-robot";
  version = "9.0.2";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-universal-robot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yswXIuuX1Mcc8DcaNiuCmA24r5LPd4+O+dZ/0YZn5Y8=";
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

  propagatedBuildInputs = [
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
    description = "Data specific to robots ur5 and ur10";
    homepage = "https://github.com/humanoid-path-planner/hpp-universal-robot";
    changelog = "https://github.com/humanoid-path-planner/hpp-universal-robot/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
