{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  hpp-core,
  hpp-manipulation,

  # buildInputs
  jrl-cmakemodules,
  python3Packages,
  toppra,

  # checkInputs
  catch2_3,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-toppra";
  version = "9.0.2";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-toppra";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ecWv5LOXZcP+VUl11gR3nI+jV2jDoNknORJREJOAGJw=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs ++ [
    python3Packages.python
  ];

  buildInputs = [
    jrl-cmakemodules
    hpp-core
    hpp-manipulation
    python3Packages.boost
    python3Packages.eigenpy
    python3Packages.numpy
    python3Packages.hpp-python
    toppra
  ];

  checkInputs = [
    catch2_3
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Integration of TOPPRA algorithm in HPP";
    homepage = "https://github.com/humanoid-path-planner/hpp-toppra";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.all;
  };
})
