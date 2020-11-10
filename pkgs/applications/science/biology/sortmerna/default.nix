{ stdenv, cmake, rocksdb, rapidjson, pkgconfig, fetchFromGitHub, fetchpatch, zlib }:

stdenv.mkDerivation rec {
  pname = "sortmerna";
  version = "4.2.0";

  src = fetchFromGitHub {
    repo = pname;
    owner = "biocore";
    rev = "v${version}";
    sha256 = "0r91viylzr069jm7kpcgb45kagvf8sqcj5zc1af4arl9sgfs1f3j";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ zlib rocksdb rapidjson ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
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
  '';

  meta = with stdenv.lib; {
    description = "Tools for filtering, mapping, and OTU-picking from shotgun genomics data";
    license = licenses.lgpl3;
    platforms = platforms.x86_64;
    homepage = "https://bioinfo.lifl.fr/RNA/sortmerna/";
    maintainers = with maintainers; [ luispedro ];
  };
}
