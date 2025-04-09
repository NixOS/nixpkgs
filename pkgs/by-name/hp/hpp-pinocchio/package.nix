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
  example-robot-data,
  hpp-environments,
  hpp-util,
  pinocchio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-pinocchio";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-pinocchio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SDH129hkDTfLBkKBHkqxGng9G3Wd7dbLCarHJhOFryc=";
  };

  # Update for pinocchio v3.5.0
  # ref. https://github.com/humanoid-path-planner/hpp-pinocchio/pull/234
  # These were merged upstream and can be removed on next release
  patches = [
    (fetchpatch {
      url = "https://github.com/humanoid-path-planner/hpp-pinocchio/commit/e542606c5a0f4f7b3080c2d12b70b37301efade4.patch";
      hash = "sha256-HC+Vd+ip+zq7ogFXfYLmKDHJyPwFHr5uIH4KAI2HMFE=";
    })
    (fetchpatch {
      url = "https://github.com/humanoid-path-planner/hpp-pinocchio/commit/26f5e996f2be210da47111af5f5a24681313d94b.patch";
      hash = "sha256-npsr3bNsSzqmZ32xmUJh2G8jnlH8Jzkqvtt3v1u9EuA=";
    })
    (fetchpatch {
      url = "https://github.com/humanoid-path-planner/hpp-pinocchio/commit/acccdc88414966ce6284792212cf3b4262a3dc8c.patch";
      hash = "sha256-/oVxJlIBc1nRdsEkWVSehiEOmoz1QusiYXT2Uc40m0w=";
    })
    (fetchpatch {
      url = "https://github.com/humanoid-path-planner/hpp-pinocchio/commit/eae6838a3802533ae82529a0308c59237d17737b.patch";
      hash = "sha256-i+i5k+CJUCHOfHmD7edmBZtykTrg7iq1/b1evYGrC+A=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ];
  propagatedBuildInputs = [
    example-robot-data
    hpp-environments
    hpp-util
    pinocchio
  ];

  doCheck = true;

  meta = {
    description = "Wrapping of Pinocchio library into HPP";
    homepage = "https://github.com/humanoid-path-planner/hpp-pinocchio";
    changelog = "https://github.com/humanoid-path-planner/hpp-pinocchio/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
