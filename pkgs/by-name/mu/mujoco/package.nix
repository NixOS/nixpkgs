{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fetchFromGitLab,
  glfw,
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
      rev = "987c57f325f7fa8472fa84e1f885f7534d391b0d";
      hash = "sha256-6Ro7miql9+wcArsOKTjlyDSyD91rmmPsIfO5auk9kiI=";
    };
    benchmark = fetchFromGitHub {
      owner = "google";
      repo = "benchmark";
      rev = "049f6e79cc3e8636cec21bbd94ed185b4a5f2653";
      hash = "sha256-VmSKKCsBvmvXSnFbw6GJRgiGjlne8rw22+RCLBV/kD4=";
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
      rev = "4be7e6b4e0a82853e853c0c7c4ef72f395e1f497";
      hash = "sha256-SOTQ9j8YCsEuxNULsulQ0bmtxOZJKF7zc4GZOQlrmdo=";
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
    qhull = fetchFromGitHub {
      owner = "qhull";
      repo = "qhull";
      rev = "62ccc56af071eaa478bef6ed41fd7a55d3bb2d80";
      hash = "sha256-kIxHtE0L/axV9WKnQzyFN0mxoIFAI33Z+MP0P/MtQPw=";
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
    trianglemeshdistance = fetchFromGitHub {
      owner = "InteractiveComputerGraphics";
      repo = "TriangleMeshDistance";
      rev = "2cb643de1436e1ba8e2be49b07ec5491ac604457";
      hash = "sha256-qG/8QKpOnUpUQJ1nLj+DFoLnUr+9oYkJPqUhwEQD2pc=";
    };
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "mujoco";
  version = "3.3.6";

  # Bumping version? Make sure to look though the MuJoCo's commit
  # history for bumped dependency pins!
  src = fetchFromGitHub {
    owner = "google-deepmind";
    repo = "mujoco";
    tag = finalAttrs.version;
    hash = "sha256-6lZ36XFMsjzck/ouSSiX47+dxbEzXgrMhw1Mi3PEnq4=";
  };

  patches = [ ./mujoco-system-deps-dont-fetch.patch ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    glm

    # non-numerical
    spdlog
    cereal
    glfw
  ];

  cmakeFlags = [
    (lib.cmakeBool "MUJOCO_SIMULATE_USE_SYSTEM_GLFW" true)
    (lib.cmakeBool "MUJOCO_SAMPLES_USE_SYSTEM_GLFW" true)
  ];

  # Move things into place so that cmake doesn't try downloading dependencies.
  preConfigure = ''
    mkdir -p build/_deps
    ln -s ${pin.abseil-cpp} build/_deps/abseil-cpp-src
    ln -s ${pin.benchmark} build/_deps/benchmark-src
    ln -s ${pin.ccd} build/_deps/ccd-src
    ln -s ${pin.eigen3} build/_deps/eigen3-src
    ln -s ${pin.googletest} build/_deps/googletest-src
    ln -s ${pin.lodepng} build/_deps/lodepng-src
    ln -s ${pin.qhull} build/_deps/qhull-src
    ln -s ${pin.tinyobjloader} build/_deps/tinyobjloader-src
    ln -s ${pin.tinyxml2} build/_deps/tinyxml2-src
    ln -s ${pin.trianglemeshdistance} build/_deps/trianglemeshdistance-src
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
