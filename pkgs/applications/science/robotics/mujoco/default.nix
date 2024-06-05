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

    # See https://github.com/google-deepmind/mujoco/blob/<VERSION>/cmake/MujocoDependencies.cmake#L17-L64
    abseil-cpp = fetchFromGitHub {
      owner = "abseil";
      repo = "abseil-cpp";
      rev = "d7aaad83b488fd62bd51c81ecf16cd938532cc0a";
      hash = "sha256-eA2/dZpNOlex1O5PNa3XSZhpMB3AmaIoHzVDI9TD/cg=";
    };
    benchmark = fetchFromGitHub {
      owner = "google";
      repo = "benchmark";
      rev = "e45585a4b8e75c28479fa4107182c28172799640";
      hash = "sha256-pgHvmRpPd99ePUVRsi7WXLVSZngZ5q6r1vWW4mdGvxY=";
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
      rev = "2a9055b50ed22101da7d77e999b90ed50956fe0b";
      hash = "sha256-tx/XR7xJ7IMh5RMvL8wRo/g+dfD3xcjZkLPSY4D9HaY=";
    };
    googletest = fetchFromGitHub {
      owner = "google";
      repo = "googletest";
      rev = "f8d7d77c06936315286eb55f8de22cd23c188571";
      hash = "sha256-t0RchAHTJbuI5YW4uyBPykTvcjy90JW9AOPNjIhwh6U=";
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
  version = "3.1.6";

  # Bumping version? Make sure to look though the MuJoCo's commit
  # history for bumped dependency pins!
  src = fetchFromGitHub {
    owner = "google-deepmind";
    repo = "mujoco";
    rev = "refs/tags/${version}";
    hash = "sha256-64zUplr1E5WSb5RpTW9La1zKVT67a1VrftiUqc2SHlU=";
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
    description = "Multi-Joint dynamics with Contact. A general purpose physics simulator.";
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
