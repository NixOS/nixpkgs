{ cmake
, fetchFromGitHub
, fetchFromGitLab
, git
, lib
, libGL
, stdenv
, xorg
}:

let
<<<<<<< HEAD
  # See https://github.com/deepmind/mujoco/blob/c9246e1f5006379d599e0bcddf159a8616d31441/cmake/MujocoDependencies.cmake#L17-L55
  abseil-cpp = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = "c2435f8342c2d0ed8101cb43adfd605fdc52dca2";
    hash = "sha256-PLoI7ix+reUqkZ947kWzls8lujYqWXk9A9a55UcfahI=";
=======
  # See https://github.com/deepmind/mujoco/blob/573d331b69845c5d651b70f5d1b0f3a0d2a3a233/cmake/MujocoDependencies.cmake#L21-L59
  abseil-cpp = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = "8c0b94e793a66495e0b1f34a5eb26bd7dc672db0";
    hash = "sha256-Od1FZOOWEXVQsnZBwGjDIExi6LdYtomyL0STR44SsG8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  benchmark = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
<<<<<<< HEAD
    rev = "2dd015dfef425c866d9a43f2c67d8b52d709acb6";
    hash = "sha256-pUW9YVaujs/y00/SiPqDgK4wvVsaM7QUp/65k0t7Yr0=";
=======
    rev = "d845b7b3a27d54ad96280a29d61fa8988d4fddcf";
    hash = "sha256-XTnTM1k6xMGXUws/fKdJUbpCPcc4U0IelL6BPEEnpEQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    rev = "211c5dfc6741a5570ad007983c113ef4d144f9f3";
    hash = "sha256-oT/h8QkL0vwaflh46Zsnu9Db1b65AP6p//nAga8M5jI=";
=======
    rev = "3bb6a48d8c171cf20b5f8e48bfb4e424fbd4f79e";
    hash = "sha256-k71DoEsx8JpC9AlQ0cCRI0fWMIWFBFL/Yscx+2iBtNM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  googletest = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
<<<<<<< HEAD
    rev = "b796f7d44681514f58a683a3a71ff17c94edb0c1";
    hash = "sha256-LVLEn+e7c8013pwiLzJiiIObyrlbBHYaioO/SWbItPQ=";
=======
    rev = "58d77fa8070e8cec2dc1ed015d66b454c8d78850";
    hash = "sha256-W+OxRTVtemt2esw4P7IyGWXOonUN5ZuscjvzqkYvZbM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    rev = "0c8fc90d2037588024d9964515c1e684f6007ecc";
    hash = "sha256-Ptzxad3ewmKJbbcmrBT+os4b4SR976zlCG9F0nq0x94=";
=======
    rev = "3df027b91202cf179f3fba3c46eebe65bbac3790";
    hash = "sha256-aHO5n9Y35C7/zb3surfMyjyMjo109DoZnkozhiAKpYQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    rev = "9a89766acc42ddfa9e7133c7d81a5bda108a0ade";
    hash = "sha256-YGAe4+Ttv/xeou+9FoJjmQCKgzupTYdDhd+gzvtz/88=";
  };

  # See https://github.com/deepmind/mujoco/blob/c9246e1f5006379d599e0bcddf159a8616d31441/simulate/cmake/SimulateDependencies.cmake#L32-L35
  glfw3 = fetchFromGitHub {
=======
    rev = "1dee28e51f9175a31955b9791c74c430fe13dc82";
    hash = "sha256-AQQOctXi7sWIH/VOeSUClX6hlm1raEQUOp+VoPjLM14=";
  };

  # See https://github.com/deepmind/mujoco/blob/573d331b69845c5d651b70f5d1b0f3a0d2a3a233/simulate/cmake/SimulateDependencies.cmake#L32-L35
  glfw = fetchFromGitHub {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    owner = "glfw";
    repo = "glfw";
    rev = "7482de6071d21db77a7236155da44c172a7f6c9e";
    hash = "sha256-4+H0IXjAwbL5mAWfsIVhW0BSJhcWjkQx4j2TrzZ3aIo=";
  };
in
stdenv.mkDerivation rec {
  pname = "mujoco";
<<<<<<< HEAD
  version = "2.3.7";
=======
  version = "2.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-LgpA+iPGqciHuWBSD6/7yvZ7p+vo48ZYKjjrDZSnAwE=";
=======
    hash = "sha256-FxMaXl7yfUAyY6LE1sxaw226dBtp1DOCWNnROp0WX2I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [ ./dependencies.patch ];

  nativeBuildInputs = [ cmake git ];

  buildInputs = [
    libGL
    xorg.libX11
    xorg.libXcursor
    xorg.libXext
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
  ];

  # Move things into place so that cmake doesn't try downloading dependencies.
  preConfigure = ''
    mkdir -p build/_deps
    ln -s ${abseil-cpp} build/_deps/abseil-cpp-src
    ln -s ${benchmark} build/_deps/benchmark-src
    ln -s ${ccd} build/_deps/ccd-src
    ln -s ${eigen3} build/_deps/eigen3-src
<<<<<<< HEAD
    ln -s ${glfw3} build/_deps/glfw3-src
=======
    ln -s ${glfw} build/_deps/glfw-src
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ln -s ${googletest} build/_deps/googletest-src
    ln -s ${lodepng} build/_deps/lodepng-src
    ln -s ${qhull} build/_deps/qhull-src
    ln -s ${tinyobjloader} build/_deps/tinyobjloader-src
    ln -s ${tinyxml2} build/_deps/tinyxml2-src
  '';

  meta = with lib; {
    description = "Multi-Joint dynamics with Contact. A general purpose physics simulator.";
    homepage = "https://mujoco.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ samuela ];
  };
}
