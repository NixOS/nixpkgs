{
  cmake,
  doxygen,
  example-robot-data,
  fetchFromGitHub,
  jrl-cmakemodules,
  lib,
  pkg-config,
  python3Packages,
  pythonSupport ? false,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-baxter";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-baxter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AdEmaDGlmlbHF+pUD9FbVZU3wwxBSKNfsknLKxuuf/c=";
  };

  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ] ++ lib.optional pythonSupport python3Packages.python;
  propagatedBuildInputs = [
    jrl-cmakemodules
    example-robot-data
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
  ];

  doCheck = true;

  meta = {
    description = "Wrappers for Baxter robot in HPP";
    homepage = "https://github.com/humanoid-path-planner/hpp-baxter";
    changelog = "https://github.com/humanoid-path-planner/hpp-baxter/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
