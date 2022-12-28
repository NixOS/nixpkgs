{ stdenv
, lib
, fetchFromGitHub
, fetchurl
, runCommand
, cmake

# Dependencies
, boost178
, clipper
, libarcus
, protobuf
, rapidjson
, stb
}:
let
  # curaengine maintained its own `Findstb.cmake` in the past,
  # but it was remove as part of their switch to `conan` in
  #   https://github.com/Ultimaker/CuraEngine/commit/9f46b87fc9c85bfa46a678927f076644f6102e94
  # We revive it here from the parent commit since it's unclear
  # how nixpkgs's cmake should find it otherwise.
  FindStbCmake = ./cmake/FindStb.cmake;
  # FindStbCmake = fetchurl {
  #   url = "https://raw.githubusercontent.com/Ultimaker/CuraEngine/ddbc941b28f1ec9442384185923e9e4f300461f2/cmake/Findstb.cmake";
  #   sha256 = "176fhfp05khb7bl3zsk0msk18lx9fasxkd8vzlvxaxnfnw7g6r0k";
  # };
  FindStbCmakeDarknetROS = fetchurl {
    url = "https://raw.githubusercontent.com/dustism/darknet_ros/20bdb7e83b42bf8f86595970cedc43928bf9028c/darknet_ros/cmake/Modules/FindStb.cmake";
    sha256 = "0r6pfch73mrjzjj8063j59pkski6qaci100qv6lplf2iyyj78dd9";
  };

  FindClipperCmake = fetchurl {
    url = "https://raw.githubusercontent.com/tamasmeszaros/libnest2d/11f1a8e8b7344008edc3fa0d4ff7b09253b153bb/cmake_modules/FindClipper.cmake";
    sha256 = "12z1400a796j1i9brppvya1nd6bycxq5vkpcw43zpjgsisch004h";
  };
  # Make a directory that contains all of the extra `.cmake` files,
  # so we can provide it with `-DCMAKE_MODULE_PATH`.
  # Note that CMake is case sensitive on non-Windows for these file names!
  ExtraFindCmakeDir = runCommand "curaengine-cmake-dir" {} ''
    mkdir -p $out
    # ln -s ${FindStbCmakeDarknetROS} $out/Findstb.cmake
    ln -s ${FindStbCmake} $out/FindStb.cmake
    ln -s ${FindClipperCmake} $out/FindClipper.cmake
  '';

  in
stdenv.mkDerivation rec {
  pname = "curaengine";
  version = "5.0.0";

  # src = fetchFromGitHub {
  #   owner = "Ultimaker";
  #   repo = "CuraEngine";
  #   # TODO: This upstream commit is slightly after the 5.0.0 release.
  #   #       Switch back to `rev = version;` on the next release that has this fix:
  #   #       https://github.com/Ultimaker/CuraEngine/commit/bb9ad578abc949c474db7a0677a355ad379ae585#diff-1e7de1ae2d059d21e1dd75d5812d5a34b0222cef273b7c3a2af62eb747f9d20aL262
  #   #       for https://github.com/Ultimaker/CuraEngine/issues/1650
  #   rev = "41989f284a7350b9d70b0ae2d4e53b6a16adf9c9";
  #   sha256 = "10kmv388mhgy4sl0jrb4x8ypm00176mxvzbf5b6z6639xzr98jnk";
  # };
  # src = lib.cleanSource /home/niklas/src/CuraEngine;
  src = fetchFromGitHub {
    owner = "nh2";
    repo = "CuraEngine";
    rev = "9be6b828b4a42866e5c407b1da4012dd6ad1c84c";
    sha256 = "sha256-W26XY0o4xJ8zWoikIlHy0R9Q9lsu85DRrf8dLxkgGZ8=";
  };

  nativeBuildInputs = [
    cmake
    boost178 # Change to `boost` once nixpkgs default boost is >= 1.78
    rapidjson
    stb
  ];
  buildInputs = [
    clipper
    libarcus
    protobuf
  ];

  cmakeFlags = [
    "-DCURA_ENGINE_VERSION=${version}"
    # "-Darcus_DIR=${lib.getLib libarcus}/lib/cmake/Arcus"
    # "-DCMAKE_PREFIX_PATH=${lib.getDev libarcus}/lib/cmake/Arcus"
    # "--log-level=DEBUG"
    # "-Dclipper_DIR=${lib.getLib clipper}"
    # "-Dclipper_INCLUDE_DIR=${lib.getDev clipper}/include"
    # "-Dclipper_LIBRARIES=${lib.getLib clipper}/lib"

    #
    "-DCMAKE_MODULE_PATH=${ExtraFindCmakeDir}"

    # "-DStb_DIR=${lib.getDev stb}/include/stb" # used by `FindStbCmakeDarknetROS` above
    "-DPC_Stb_INCLUDEDIR=${lib.getDev stb}" # used by `FindStbCmake` above

    "-DCMAKE_VERBOSE_MAKEFILE=1"
  ];

  meta = with lib; {
    description = "A powerful, fast and robust engine for processing 3D models into 3D printing instruction";
    homepage = "https://github.com/Ultimaker/CuraEngine";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar gebner ];
  };
}
