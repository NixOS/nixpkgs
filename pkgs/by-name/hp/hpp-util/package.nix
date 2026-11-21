{
  lib,
  fetchFromGitHub,
  stdenv,

  # buildInputs
  jrl-cmakemodules,

  # propagatedBuildInputs
  boost,
  tinyxml-2,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-util";
  version = "9.0.2";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-util";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+lHDypQIqNPYzfpMVTrj/A553Igo5CEOzuid7Segl0I=";
  };

  prePatch = ''
    patchShebangs --build tests/run_debug.sh.in
  '';

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs;

  buildInputs = [
    jrl-cmakemodules
  ];

  propagatedBuildInputs = [
    boost
    tinyxml-2
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Debugging tools for the HPP project";
    homepage = "https://github.com/humanoid-path-planner/hpp-util";
    changelog = "https://github.com/humanoid-path-planner/hpp-util/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
