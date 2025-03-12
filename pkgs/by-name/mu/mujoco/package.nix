{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fetchFromGitLab,
  glfw,
  glm,
  spdlog,
  cereal_1_3_2,
  python3Packages,
}:

let
  pin = {
    # TODO: Check the following file and ensure the dependencies are up-to-date
    # See https://github.com/google-deepmind/mujoco/blob/<VERSION>/cmake/MujocoDependencies.cmake#L17-L64
    abseil-cpp = fetchFromGitHub {
      owner = "abseil";
      repo = "abseil-cpp";
      rev = "9ac7062b1860d895fb5a8cbf58c3e9ef8f674b5f";
      hash = "sha256-uOgUtF8gaEgcxFK9WAoAhv4GoS8P23IoUxHZZVZdpPk=";
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
      rev = "66f7f51b7e069d0a03a21157fa60b24aece69aeb";
      hash = "sha256-/xd0GnXoW8vclIk8aKAziQwDx6AdlBmZD48p8aCX6TQ=";
    };
    googletest = fetchFromGitHub {
      owner = "google";
      repo = "googletest";
      rev = "6910c9d9165801d8827d628cb72eb7ea9dd538c5";
      hash = "sha256-01PK9LxqHno89gypd7ze5gDP4V3en2J5g6JZRqohDB0=";
    };
    lodepng = fetchFromGitHub {
      owner = "lvandeve";
      repo = "lodepng";
      rev = "b4ed2cd7ecf61d29076169b49199371456d4f90b";
      hash = "sha256-5cCkdj/izP4e99BKfs/Mnwu9aatYXjlyxzzYiMD/y1M=";
    };
    qhull = fetchFromGitHub {
      owner = "qhull";
      repo = "qhull";
      rev = "0c8fc90d2037588024d9964515c1e684f6007ecc";
      hash = "sha256-Ptzxad3ewmKJbbcmrBT+os4b4SR976zlCG9F0nq0x94=";
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
      rev = "9a89766acc42ddfa9e7133c7d81a5bda108a0ade";
      hash = "sha256-YGAe4+Ttv/xeou+9FoJjmQCKgzupTYdDhd+gzvtz/88=";
    };
    marchingcubecpp = fetchFromGitHub {
      owner = "aparis69";
      repo = "MarchingCubeCpp";
      rev = "f03a1b3ec29b1d7d865691ca8aea4f1eb2c2873d";
      hash = "sha256-90ei0lpJA8XuVGI0rGb3md0Qtq8/bdkU7dUCHpp88Bw=";
    };

    tmd = stdenv.mkDerivation {
      name = "TriangleMeshDistance";

      src = fetchFromGitHub {
        owner = "InteractiveComputerGraphics";
        repo = "TriangleMeshDistance";
        rev = "e55a15c20551f36242fd6368df099a99de71d43a";
        hash = "sha256-vj6TMMT8mp7ciLa5nzVAhMWPcAHXq+ZwHlWsRA3uCmg=";
      };

      installPhase = ''
        mkdir -p $out/include/tmd
        cp TriangleMeshDistance/include/tmd/TriangleMeshDistance.h $out/include/tmd/
      '';
    };

    sdflib = stdenv.mkDerivation {
      name = "SdfLib";

      src = fetchFromGitHub {
        owner = "UPC-ViRVIG";
        repo = "SdfLib";
        rev = "1927bee6bb8225258a39c8cbf14e18a4d50409ae";
        hash = "sha256-+SFUOdZ6pGZvnQa0mT+yfbTMHWe2CTOlroXcuVBHdOE=";
      };

      patches = [ ./sdflib-system-deps.patch ];

      cmakeFlags = [
        (lib.cmakeBool "SDFLIB_USE_ASSIMP" false)
        (lib.cmakeBool "SDFLIB_USE_OPENMP" false)
        (lib.cmakeBool "SDFLIB_USE_ENOKI" false)
        (lib.cmakeBool "SDFLIB_USE_SYSTEM_GLM" true)
        (lib.cmakeBool "SDFLIB_USE_SYSTEM_SPDLOG" true)
        (lib.cmakeBool "SDFLIB_USE_SYSTEM_CEREAL" true)
        (lib.cmakeBool "SDFLIB_USE_SYSTEM_TRIANGLEMESHDISTANCE" true)
      ];

      nativeBuildInputs = [ cmake ];
      buildInputs = [
        pin.tmd

        # Mainline. The otherwise pinned glm release from 2018 does
        # not build due to test failures and missing files.
        glm

        spdlog
        cereal_1_3_2
      ];
    };

  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "mujoco";
  version = "3.3.0";

  # Bumping version? Make sure to look though the MuJoCo's commit
  # history for bumped dependency pins!
  src = fetchFromGitHub {
    owner = "google-deepmind";
    repo = "mujoco";
    tag = finalAttrs.version;
    hash = "sha256-6Mb50WD5ZQksKoG4FH3+iyy9qBqa1fKUPyt6McNDkGg=";
  };

  patches = [ ./mujoco-system-deps-dont-fetch.patch ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    pin.sdflib
    glm

    # non-numerical
    spdlog
    cereal_1_3_2
    glfw
  ];

  cmakeFlags = [
    (lib.cmakeBool "MUJOCO_USE_SYSTEM_sdflib" true)
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
    ln -s ${pin.marchingcubecpp} build/_deps/marchingcubecpp-src
  '';

  passthru = {
    pin = {
      inherit (pin) lodepng eigen3 abseil-cpp;
    };
    tests = {
      pythonMujoco = python3Packages.mujoco;
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
