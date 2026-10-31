{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  cpm-cmake,
  rapids-logger,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rapids-cmake";
  version = "26.10.00";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rapidsai";
    repo = "rapids-cmake";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6w90XfVJPL05pMyVV2AaCi9PRkECfMDz3qM3Lfb3pc0=";
  };

  dontConfigure = true;
  dontBuild = true;

  # these modules find each other relative to `rapids-cmake/`, so preserve
  # the layout from src
  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/rapids-cmake \
      CMakeLists.txt \
      RAPIDS.cmake \
      init.cmake \
      RAPIDS_BRANCH \
      VERSION
    cp -r rapids-cmake $out/share/rapids-cmake/rapids-cmake

    install -Dm644 -t $out/share/doc/rapids-cmake README.md CHANGELOG.md

    runHook postInstall
  '';

  setupHook = ./setup-hook.sh;
  env.cpm = cpm-cmake;

  passthru.tests = {
    # presumably if the rapids-logger cmake check works then
    # rapids-cmake is installed correctly
    inherit (rapids-logger.tests) cmake-config;
  };

  meta = {
    description = "CMake modules shared across RAPIDS projects";
    homepage = "https://github.com/rapidsai/rapids-cmake";
    changelog = "https://github.com/rapidsai/rapids-cmake/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    platforms = lib.platforms.all;
  };
})
