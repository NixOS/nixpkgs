{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gitMinimal,
  fetchFromGitLab,
  glfw,
  libGL,
  glm,
  spdlog,
  cereal,
  python3Packages,
}:

let
  pin = {
    # TODO: Check the following file and ensure the dependencies are up-to-date
    # See https://github.com/google-deepmind/mujoco/blob/<VERSION>/cmake/MujocoDependencies.cmake#L17-L64
    abseil-cpp = fetchFromGitHub {
      owner = "abseil";
      repo = "abseil-cpp";
      rev = "5650e9cf76d3be4318d5fa3af38ee483ddfd5e4a";
      hash = "sha256-O9ClnGm4WSTX3g1Q2VYTMhUtGG52XBwxzgHtWW9WSG0=";
    };
    benchmark = fetchFromGitHub {
      owner = "google";
      repo = "benchmark";
      rev = "834a61fc65e8b7885fcf177f1230ae4b897118fa";
      hash = "sha256-V5pVCG5QdFlgBIVKMv4jyTTB22BWfTHD3HolVPDFpgQ=";
    };
    ccd = fetchFromGitHub {
      owner = "danfis";
      repo = "libccd";
      rev = "7931e764a19ef6b21b443376c699bbc9c6d4fba8";
      hash = "sha256-TIZkmqQXa0+bSWpqffIgaBela0/INNsX9LPM026x1Wk=";
    };
    eigen3 = fetchFromGitLab {
      owner = "libeigen";
      repo = "eigen";
      rev = "ea13a98decd497a8c5588fb5de71b57bcf10d864";
      hash = "sha256-v9bNWc9yfK3vG8hYhQ7vkc7DHaoPF6RAKfX9kC0Gw8c=";
    };
    googletest = fetchFromGitHub {
      owner = "google";
      repo = "googletest";
      rev = "52eb8108c5bdec04579160ae17225d66034bd723";
      hash = "sha256-HIHMxAUR4bjmFLoltJeIAVSulVQ6kVuIT2Ku+lwAx/4=";
    };
    lodepng = fetchFromGitHub {
      owner = "lvandeve";
      repo = "lodepng";
      rev = "17d08dd26cac4d63f43af217ebd70318bfb8189c";
      hash = "sha256-vnw52G0lY68471dzH7NXc++bTbLRsITSxGYXOTicA5w=";
    };
    miniz = fetchFromGitHub {
      owner = "richgel999";
      repo = "miniz";
      rev = "d10b03cc73475af673df40f06e5cefd1d5f940d9";
      hash = "sha256-hRB/0TVVQjr4VwjozfRnYKUJfeqO+1PNfdvP/rrOCR4=";
    };
    qhull = fetchFromGitHub {
      owner = "qhull";
      repo = "qhull";
      rev = "d1c2fc0caa5f644f3a0f220290d4a868c68ed4f6";
      hash = "sha256-enwzl4td3lgYwQ4PXfcONKQrxChnJcvf8ehnJ6vf0yg=";
    };
    tinyobjloader = fetchFromGitHub {
      owner = "tinyobjloader";
      repo = "tinyobjloader";
      rev = "1421a10d6ed9742f5b2c1766d22faa6cfbc56248";
      hash = "sha256-9z2Ne/WPCiXkQpT8Cun/pSGUwgClYH+kQ6Dx1JvW6w0=";
    };
    tinyxml2 = fetchFromGitHub {
      owner = "leethomason";
      repo = "tinyxml2";
      rev = "e6caeae85799003f4ca74ff26ee16a789bc2af48";
      hash = "sha256-GpFFWl7/1XF1vTOxUrEo27T4Kc6oaUMvhGp9xLQfmWg=";
    };
    marchingcubecpp = fetchFromGitHub {
      owner = "aparis69";
      repo = "MarchingCubeCpp";
      rev = "f03a1b3ec29b1d7d865691ca8aea4f1eb2c2873d";
      hash = "sha256-90ei0lpJA8XuVGI0rGb3md0Qtq8/bdkU7dUCHpp88Bw=";
    };
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "mujoco";
  version = "3.10.0";

  __structuredAttrs = true;
  strictDeps = true;

  # Bumping version? Make sure to look though the MuJoCo's commit
  # history for bumped dependency pins!
  src = fetchFromGitHub {
    owner = "google-deepmind";
    repo = "mujoco";
    tag = finalAttrs.version;
    hash = "sha256-wNsTTq5z+wKE0rSw2cyY1tJxP5i7LGu05DR7KfZEBtE=";
  };

  patches = [
    ./mujoco-system-deps-dont-fetch.patch
  ];

  nativeBuildInputs = [
    cmake
    # git is needed to apply patches to ccd-src and qhull-src (see below)
    gitMinimal
  ];

  buildInputs = [
    glm

    # non-numerical
    spdlog
    cereal
    glfw
  ];

  propagatedBuildInputs = [
    # consuming MuJoCo through cmake find_package requires libGL
    libGL
  ];

  cmakeFlags = [
    (lib.cmakeBool "MUJOCO_SIMULATE_USE_SYSTEM_GLFW" true)
    (lib.cmakeBool "MUJOCO_SAMPLES_USE_SYSTEM_GLFW" true)
  ];

  # Move things into place so that cmake doesn't try downloading dependencies.
  preConfigure = ''
    mkdir -p build/_deps
    ln -s ${pin.benchmark} build/_deps/benchmark-src
  ''
  # mujoco applies a patch on top of abseil-cpp's sources
  # https://github.com/google-deepmind/mujoco/blob/3.10.0/cmake/MujocoDependencies.cmake#L299-L300
  + ''
    cp -r ${pin.abseil-cpp} build/_deps/abseil-cpp-src
    chmod -R +w build/_deps/abseil-cpp-src
  ''
  # cccd is patched by mujoco's cmake and thus needs to be writable
  # https://github.com/google-deepmind/mujoco/blob/3.4.0/cmake/MujocoDependencies.cmake#L232-L235
  + ''
    cp -r ${pin.ccd} build/_deps/ccd-src
    chmod -R +w build/_deps/ccd-src
  ''
  + ''
    ln -s ${pin.eigen3} build/_deps/eigen3-src
    ln -s ${pin.googletest} build/_deps/googletest-src
    ln -s ${pin.lodepng} build/_deps/lodepng-src
    ln -s ${pin.miniz} build/_deps/miniz-src
  ''
  # qhull is patched by mujoco's cmake and thus needs to be writable
  # https://github.com/google-deepmind/mujoco/blob/3.4.0/cmake/MujocoDependencies.cmake#L132-L135
  + ''
    cp -r ${pin.qhull} build/_deps/qhull-src
    chmod -R +w build/_deps/qhull-src
  ''
  + ''
    ln -s ${pin.tinyobjloader} build/_deps/tinyobjloader-src
    ln -s ${pin.tinyxml2} build/_deps/tinyxml2-src
    ln -s ${pin.marchingcubecpp} build/_deps/marchingcubecpp-src
  '';

  passthru = {
    pin = {
      inherit (pin) lodepng eigen3 abseil-cpp;
    };
    tests = {
      pythonMujoco = python3Packages.mujoco;
      pythonMujocoMjx = python3Packages.mujoco-mjx;
    };
  };

  meta = {
    description = "Multi-Joint dynamics with Contact. A general purpose physics simulator";
    homepage = "https://mujoco.org/";
    changelog = "https://mujoco.readthedocs.io/en/${finalAttrs.version}/changelog.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
      samuela
      tmplt
    ];
    broken = stdenv.hostPlatform.isDarwin;
  };
})
