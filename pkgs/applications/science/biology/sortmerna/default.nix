{
  lib,
  stdenv,
  cmake,
  rocksdb_8_3,
  rapidjson,
  pkg-config,
  fetchFromGitHub,
  zlib,
}:

let
  rocksdb = rocksdb_8_3;
in
stdenv.mkDerivation rec {
  pname = "sortmerna";
  version = "4.2.0";

  src = fetchFromGitHub {
    repo = pname;
    owner = "biocore";
    rev = "v${version}";
    sha256 = "0r91viylzr069jm7kpcgb45kagvf8sqcj5zc1af4arl9sgfs1f3j";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    zlib
    rocksdb
    rapidjson
  ];

  cmakeFlags = [
    "-DPORTABLE=off"
    "-DRAPIDJSON_HOME=${rapidjson}"
    "-DROCKSDB_HOME=${rocksdb}"
    "-DROCKSDB_STATIC=off"
    "-DZLIB_STATIC=off"
  ];

  postPatch = ''
    # Fix formatting string error:
    # https://github.com/biocore/sortmerna/issues/255
    substituteInPlace src/sortmerna/indexdb.cpp \
      --replace 'is_verbose, ss' 'is_verbose, "%s", ss'

    # Fix missing pthread dependency for the main binary.
    substituteInPlace src/sortmerna/CMakeLists.txt \
      --replace "target_link_libraries(sortmerna" \
        "target_link_libraries(sortmerna Threads::Threads"

    # Fix gcc-13 build by adding missing <cstdint> includes:
    #   https://github.com/sortmerna/sortmerna/issues/412
    sed -e '1i #include <cstdint>' -i include/kseq_load.hpp
  '';

  meta = with lib; {
    description = "Tools for filtering, mapping, and OTU-picking from shotgun genomics data";
    mainProgram = "sortmerna";
    license = licenses.lgpl3;
    platforms = platforms.x86_64;
    homepage = "https://bioinfo.lifl.fr/RNA/sortmerna/";
    maintainers = with maintainers; [ luispedro ];
    broken = stdenv.isDarwin;
  };
}
