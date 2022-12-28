{ stdenv
, lib
, fetchFromGitHub
, fetchurl
, fetchpatch
, runCommand
, cmake

# Dependencies
, boost
, clipper
, libarcus
, protobuf
, range-v3
, rapidjson
, stb
, spdlog
}:
let
  # curaengine maintained its own `Findstb.cmake` in the past,
  # but it was remove as part of their switch to `conan` in
  #   https://github.com/Ultimaker/CuraEngine/commit/9f46b87fc9c85bfa46a678927f076644f6102e94
  # We revive it here from the parent commit since it's unclear
  # how nixpkgs's cmake should find it otherwise.
  FindStbCmake = ./cmake/FindStb.cmake;

  # Make a directory that contains all of the extra `.cmake` files,
  # so we can provide it with `-DCMAKE_MODULE_PATH`.
  # Note that CMake is case sensitive on non-Windows for these file names!
  ExtraFindCmakeDir = runCommand "curaengine-cmake-dir" {} ''
    mkdir -p $out
    ln -s ${FindStbCmake} $out/FindStb.cmake
  '';

  in
stdenv.mkDerivation rec {
  pname = "curaengine";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "CuraEngine";
    rev = version;
    sha256 = "03267hm5vjd6fs2ggdn8rc92xrx0ilfkpvmdf2lf0f0w6p3s534w";
  };

  patches = [
    # Imported from Alpine:
    (fetchpatch {
      url = "https://git.alpinelinux.org/aports/plain/community/curaengine/cmake-helpers.patch?id=0c8c8327f0fd55c277778637f444a22961af3fcf";
      name = "curaengine-cmake-helpers.patch";
      sha256 = "1zn4yipcl6jxzs0bjclss64wcyq71h8sgik2bbb94jl4pnammvmm";
    })
    # Imported from Alpine:
    (fetchpatch {
      url = "https://git.alpinelinux.org/aports/plain/community/curaengine/cmake.patch?id=0c8c8327f0fd55c277778637f444a22961af3fcf";
      name = "curaengine-cmake.patch";
      sha256 = "1g1f54h9z50c9246nz1vfnz4wkds3j87xbv6rlmm4wbcbcg107ij";
    })
  ];

  # The `cmake.patch` does
  #     -find_package(stb REQUIRED)
  # We insert it back here (as a new line after RapidJSON), but with capital `S`:
  #     find_package(Stb REQUIRED)
  # so that our `FindStb.cmake` from above (passed via `DCMAKE_MODULE_PATH`)
  # will pick up the `find_package()` and find it.
  #
  # The `cmake.patch` also does
  #     -        stb::stb
  # so we insert it back here (again with uppercase `S`) after `Boost:boost`.
  postPatch = ''
    sed -i \
      -e "s,find_package(RapidJSON REQUIRED),find_package(RapidJSON REQUIRED)\nfind_package(Stb REQUIRED)," \
      -e "s,Boost::boost$,Boost::boost\nStb::Stb," \
      CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    boost
    range-v3
    rapidjson
    stb
  ];
  buildInputs = [
    clipper
    libarcus
    protobuf
    spdlog # Apparently available in both compiled-library and header-only version; assuming the former for now (which as per its README speeds up compiles), so not putting it into `nativeBuildInputs`.
  ];

  # The `cmake-helpers.patch` added above adds `FindClipper.cmake` which calls
  # CMake's `FIND_PATH()` but only on *environment* variables (`$ENV{CLIPPER_PATH}`),
  # not CMake variables, so we cannot set this one with `cmakeFlags = [ "-D..." ]`
  # and instead set it here as an environment variable.
  CLIPPER_PATH = lib.getLib clipper;

  cmakeFlags = [
    "-DCURA_ENGINE_VERSION=${version}"

    # See comments on `ExtraFindCmakeDir` above.
    "-DCMAKE_MODULE_PATH=${ExtraFindCmakeDir}"

    # "-DCMAKE_VERBOSE_MAKEFILE=1" # enable for easier debugging of build failures
  ];

  meta = with lib; {
    description = "A powerful, fast and robust engine for processing 3D models into 3D printing instruction";
    homepage = "https://github.com/Ultimaker/CuraEngine";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar gebner ];
  };
}
