{
  lib,
  fetchFromGitHub,
  fetchpatch,
  stdenv,

  # nativeBuildInputs
  cmake,
  doxygen,
  pkg-config,

  # propagatedBuildInputs
  hpp-constraints,
  proxsuite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-core";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W4gUjvzULxUqG51zBV3P9u2XWNM7FQDK4pk/DMuWb2k=";
  };

  # Fix for pinocchio v3.5.0
  # ref. https://github.com/humanoid-path-planner/hpp-core/pull/364
  # and https://github.com/humanoid-path-planner/hpp-core/pull/378
  # this was merged upstream and can be removed on next release
  patches = [
    (fetchpatch {
      url = "https://github.com/humanoid-path-planner/hpp-core/commit/919353e3b6a10261a0e520d4db4760553062f17f.patch";
      hash = "sha256-pHaPUK+asOocGeltENeyEwx93TTKJPX0UCWWhMcFUFc=";
    })
    (fetchpatch {
      url = "https://github.com/humanoid-path-planner/hpp-core/commit/5a518ce3bc7419f30499a9e6af3391261c0b6ac2.patch";
      hash = "sha256-ixxVhovj74LpAn6Yms338agLgdyOg1aRZcsiY9KpKYE=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ];
  propagatedBuildInputs = [
    hpp-constraints
    proxsuite
  ];

  doCheck = true;

  meta = {
    description = "The core algorithms of the Humanoid Path Planner framework";
    homepage = "https://github.com/humanoid-path-planner/hpp-core";
    changelog = "https://github.com/humanoid-path-planner/hpp-core/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
