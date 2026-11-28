{
  lib,
  fetchFromGitHub,
  stdenv,

  # buildInputs
  jrl-cmakemodules,

  # propagatedBuildInputs
  coal,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-affordance";
  version = "9.0.2";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-affordance";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gh1ko4WprJsr/fYt/H5xvIYUVND0QgF5Y6YignIAmCM=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs;

  buildInputs = [
    jrl-cmakemodules
  ];

  propagatedBuildInputs = [
    coal
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Implements affordance extraction for multi-contact planning";
    homepage = "https://github.com/humanoid-path-planner/hpp-affordance";
    changelog = "https://github.com/humanoid-path-planner/hpp-affordance/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
