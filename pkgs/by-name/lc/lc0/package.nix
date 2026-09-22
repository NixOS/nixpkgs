{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  python3,
  zlib,
  gtest,
  eigen,
  abseil-cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lc0";
  version = "0.32.1";

  src = fetchFromGitHub {
    owner = "LeelaChessZero";
    repo = "lc0";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Dvq698ZfYumoax7i1nN5GwTQKXgby9+TdTZT6C7/jgc=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "absl = subproject('abseil-cpp', default_options : ['warning_level=0', 'cpp_std=c++20'])" "" \
      --replace-fail "deps += absl.get_variable('absl_container_dep').as_system()" "deps += [dependency('absl_flat_hash_map'), dependency('absl_cleanup'), dependency('absl_base')]" \
      --replace-fail "if eigen_dep.found() and cc.has_header('Eigen/Core')" "if eigen_dep.found()"
  '';

  patchPhase = ''
    runHook prePatch

    patchShebangs --build scripts/*

    runHook postPatch
  '';

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    eigen
    gtest
    zlib
    abseil-cpp
  ];

  mesonFlags = [
    "-Dplain_cuda=false"
    "-Daccelerate=false"
    "-Dmetal=disabled"
    "-Dembed=false"
  ]
  # in version 31 this option will be required
  ++ lib.optionals (lib.versionAtLeast finalAttrs.version "0.31") [ "-Dnative_cuda=false" ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    homepage = "https://lczero.org/";
    description = "Open source neural network based chess engine";
    longDescription = ''
      Lc0 is a UCI-compliant chess engine designed to play chess via neural network, specifically those of the LeelaChessZero project.
    '';
    maintainers = with lib.maintainers; [ _9glenda ];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3Plus;
    broken = stdenv.hostPlatform.isDarwin;
  };

})
