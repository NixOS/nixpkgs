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
  # See https://github.com/deepmind/mujoco/blob/c9246e1f5006379d599e0bcddf159a8616d31441/cmake/MujocoDependencies.cmake#L17-L55
  abseil-cpp = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = "c2435f8342c2d0ed8101cb43adfd605fdc52dca2";
    hash = "sha256-PLoI7ix+reUqkZ947kWzls8lujYqWXk9A9a55UcfahI=";
  };
  benchmark = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "2dd015dfef425c866d9a43f2c67d8b52d709acb6";
    hash = "sha256-pUW9YVaujs/y00/SiPqDgK4wvVsaM7QUp/65k0t7Yr0=";
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
    rev = "211c5dfc6741a5570ad007983c113ef4d144f9f3";
    hash = "sha256-oT/h8QkL0vwaflh46Zsnu9Db1b65AP6p//nAga8M5jI=";
  };
  googletest = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "b796f7d44681514f58a683a3a71ff17c94edb0c1";
    hash = "sha256-LVLEn+e7c8013pwiLzJiiIObyrlbBHYaioO/SWbItPQ=";
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

  # See https://github.com/deepmind/mujoco/blob/c9246e1f5006379d599e0bcddf159a8616d31441/simulate/cmake/SimulateDependencies.cmake#L32-L35
  glfw3 = fetchFromGitHub {
    owner = "glfw";
    repo = "glfw";
    rev = "7482de6071d21db77a7236155da44c172a7f6c9e";
    hash = "sha256-4+H0IXjAwbL5mAWfsIVhW0BSJhcWjkQx4j2TrzZ3aIo=";
  };
in
stdenv.mkDerivation rec {
  pname = "mujoco";
  version = "2.3.7";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = pname;
    rev = version;
    hash = "sha256-LgpA+iPGqciHuWBSD6/7yvZ7p+vo48ZYKjjrDZSnAwE=";
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
    ln -s ${glfw3} build/_deps/glfw3-src
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
