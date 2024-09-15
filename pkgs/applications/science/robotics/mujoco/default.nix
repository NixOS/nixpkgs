{ cereal_1_3_2
, cmake
, fetchFromGitHub
, fetchFromGitLab
, glfw
, glm
, lib
, spdlog
, stdenv
}:

let
  pin = {
    # TODO: Check the following file and ensure the dependencies are up-to-date
    # See https://github.com/google-deepmind/mujoco/blob/<VERSION>/cmake/MujocoDependencies.cmake#L17-L64
    abseil-cpp = fetchFromGitHub {
      owner = "abseil";
      repo = "abseil-cpp";
      rev = "4447c7562e3bc702ade25105912dce503f0c4010";
      hash = "sha256-51jpDhdZ0n+KLmxh8KVaTz53pZAB0dHjmILFX+OLud4=";
    };
    benchmark = fetchFromGitHub {
      owner = "google";
      repo = "benchmark";
      rev = "7c8ed6b082aa3c7a3402f18e50da4480421d08fd";
      hash = "sha256-xX3o4wX7RUvw1x2gOlT6sGhutDYLBZ/JzFnv68qN6E8=";
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
      rev = "33d0937c6bdf5ec999939fb17f2a553183d14a74";
      hash = "sha256-qmFsmFEQCDH+TRFc8+5BsYAG1ybL08fWhn8NpM6H6xY=";
    };
    googletest = fetchFromGitHub {
      owner = "google";
      repo = "googletest";
      rev = "b514bdc898e2951020cbdca1304b75f5950d1f59";
      hash = "sha256-1OJ2SeSscRBNr7zZ/a8bJGIqAnhkg45re0j3DtPfcXM=";
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

    tmd = stdenv.mkDerivation rec {
      name = "TriangleMeshDistance";

      src = fetchFromGitHub {
        owner = "InteractiveComputerGraphics";
        repo = name;
        rev = "e55a15c20551f36242fd6368df099a99de71d43a";
        hash = "sha256-vj6TMMT8mp7ciLa5nzVAhMWPcAHXq+ZwHlWsRA3uCmg=";
      };

      installPhase = ''
        mkdir -p $out/include/tmd
        cp ${name}/include/tmd/${name}.h $out/include/tmd/
      '';
    };

    sdflib = stdenv.mkDerivation rec {
      name = "SdfLib";

      src = fetchFromGitHub {
        owner = "UPC-ViRVIG";
        repo = name;
        rev = "1927bee6bb8225258a39c8cbf14e18a4d50409ae";
        hash = "sha256-+SFUOdZ6pGZvnQa0mT+yfbTMHWe2CTOlroXcuVBHdOE=";
      };

      patches = [ ./sdflib-system-deps.patch ];

      cmakeFlags = [
        "-DSDFLIB_USE_ASSIMP=OFF"
        "-DSDFLIB_USE_OPENMP=OFF"
        "-DSDFLIB_USE_ENOKI=OFF"
        "-DSDFLIB_USE_SYSTEM_GLM=ON"
        "-DSDFLIB_USE_SYSTEM_SPDLOG=ON"
        "-DSDFLIB_USE_SYSTEM_CEREAL=ON"
        "-DSDFLIB_USE_SYSTEM_TRIANGLEMESHDISTANCE=ON"
      ];

      nativeBuildInputs = [ cmake ];
      buildInputs = [
        pin.tmd

        # Mainline. The otherwise pinned glm realease from 2018 does
        # not build due to test failures and missing files.
        glm

        spdlog
        cereal_1_3_2
      ];
    };

  };

in stdenv.mkDerivation rec {
  pname = "mujoco";
  version = "3.2.2";

  # Bumping version? Make sure to look though the MuJoCo's commit
  # history for bumped dependency pins!
  src = fetchFromGitHub {
    owner = "google-deepmind";
    repo = "mujoco";
    rev = "refs/tags/${version}";
    hash = "sha256-UUPB7AY6OYWaK5uBu92kmoIE116AfFa34sYmF943AOU=";
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
    "-DMUJOCO_USE_SYSTEM_sdflib=ON"
    "-DMUJOCO_SIMULATE_USE_SYSTEM_GLFW=ON"
    "-DMUJOCO_SAMPLES_USE_SYSTEM_GLFW=ON"
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

  passthru.pin = { inherit (pin) lodepng eigen3 abseil-cpp; };

  meta = {
    description = "Multi-Joint dynamics with Contact. A general purpose physics simulator";
    homepage = "https://mujoco.org/";
    changelog = "https://github.com/google-deepmind/mujoco/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
      samuela
      tmplt
    ];
    broken = stdenv.isDarwin;
  };
}
