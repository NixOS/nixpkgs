{ lib, stdenv, fetchFromGitHub, cmake, libarcus, pkg-config, stb, protobuf, zlib, clipper, rapidjson, boost, conan }:

let withConanCMakeDeps = conan.withConanCMakeDepsFile;
arcus =
    (withConanCMakeDeps {package = libarcus; pkg_name = "arcus"; aliases = ["arcus::libarcus"];lib_search="Arcus";}); in
stdenv.mkDerivation rec {
  pname = "curaengine";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "CuraEngine";
    rev = version;
    sha256 = "sha256-DCYJDcFwfMegiro/H925MZLFyWXzvXWyEQFHCQukQQI=";
  };

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [
    (withConanCMakeDeps {package = clipper; pkg_name = "clipper"; lib_search="polyclipping";})
    arcus
    (withConanCMakeDeps {package = stb; version = "99999999999"; extra_includes="include/stb/"; })
    protobuf
    (withConanCMakeDeps {package = rapidjson;})
    (withConanCMakeDeps {package = boost.dev;pkg_name = "Boost";})
    zlib
  ];

  cmakeFlags = [
    "-DCURA_ENGINE_VERSION=${version}"
    "-DUSE_SYSTEM_LIBS=true"
    "-Dprotobuf_MODULE_COMPATIBLE=on"
    "-DCMAKE_DEBUG_TARGET_PROPERTIES=INTERFACE_INCLUDE_DIRECTORIES"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_SHARED_LIBS=ON"
    # "--debug-output"
    # "--check-system-vars"
    # "--trace-expand"
  ];

  # NIX_CFLAGS_COMPILE="-I${stb}/include -I${}";
  # NIX_LDFLAGS="-L${lib.getLib clipper}/lib -L${lib.getLib stb}/lib";

  postPatch = ''
    echo arcus = ${arcus}
    echo $CMAKE_PREFIX_PATH
    # echo ${builtins.concatStringsSep " " buildInputs}
    # exit 1
    # sed -i '2i include(CMakePackageConfigHelpers)' CMakeLists.txt
    # sed -i '2i find_package(PkgConfig)' CMakeLists.txt
    #sed -i 's|::libarcus|::arcus|' CMakeLists.txt
    # sed -i 's|find_package(protobuf REQUIRED)|find_package(Protobuf 3.17.1 REQUIRED)|' CMakeLists.txt
    # sed -i 's|find_package(clipper 6.4.2 REQUIRED)|find_library(clipper 6.4.2 REQUIRED NAMES polyclipping libpolyclipping)|g' CMakeLists.txt
    # sed -i 's|find_package(rapidjson 1.1.0 REQUIRED)|find_package(rapidjson 1.1.0 REQUIRED NAMES RapidJSON rapidjson)|g' CMakeLists.txt
    # sed -i 's|find_package(stb 20200203 REQUIRED)|find_library(stb REQUIRED NAMES stb)|g' CMakeLists.txt

    grep -ri protobuf CMakeLists.txt
  '';

  meta = with lib; {
    description = "A powerful, fast and robust engine for processing 3D models into 3D printing instruction";
    homepage = "https://github.com/Ultimaker/CuraEngine";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar gebner LunNova ];
  };
}
