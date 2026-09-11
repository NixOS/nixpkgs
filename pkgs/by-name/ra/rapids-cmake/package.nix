{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  cpm-cmake,
  rapids-logger,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rapids-cmake";
  version = "26.08.00";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rapidsai";
    repo = "rapids-cmake";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bkdeEr7nXL59WTv5x6EsHENuFft41mC4hD3Ke73NVjA=";
  };

  # rapids_cpm_cccl looks for exactly the CCCL release in versions.json (3.4.3 for 26.08), which CUDA 13.4 ships, so
  # the RAPIDS libraries fail to configure with a newer CUDA, whose CCCL is newer. CCCL's package version file accepts
  # any newer release with the same major version, so drop EXACT and accept those.
  postPatch = ''
    substituteInPlace rapids-cmake/cpm/cccl.cmake \
      --replace-fail \
        "CPM_ARGS FIND_PACKAGE_ARGUMENTS EXACT \''${cpm_find_info}" \
        "CPM_ARGS \''${cpm_find_info}"
  '';

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
