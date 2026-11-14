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
  pname = "hpp-baxter";
  version = "9.0.2";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-baxter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fFUQ2IVf9V5PH9b5xeXhU7r52N9FYRefjNUwyXaGGIk=";
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
    description = "Wrappers for Baxter robot in HPP";
    homepage = "https://github.com/humanoid-path-planner/hpp-baxter";
    changelog = "https://github.com/humanoid-path-planner/hpp-baxter/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
