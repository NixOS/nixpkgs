{ stdenv, cmake, rocksdb, rapidjson, pkgconfig, fetchFromGitHub, fetchpatch, zlib }:

stdenv.mkDerivation rec {
  pname = "sortmerna";
  version = "3.0.3";

  src = fetchFromGitHub {
    repo = pname;
    owner = "biocore";
    rev = "v${version}";
    sha256 = "0zx5fbzyr8wdr0zwphp8hhcn1xz43s5lg2ag4py5sv0pv5l1jh76";
  };

  patches = [
    (fetchpatch {
      name = "CMakeInstallPrefix.patch";
      url = "https://github.com/biocore/sortmerna/commit/4d36d620a3207e26cf3f588d4ec39889ea21eb79.patch";
      sha256 = "0hc3jwdr6ylbyigg52q8islqc0mb1k8rrjadvjfqaxnili099apd";
    })
  ];

  nativeBuildInputs = [ cmake rapidjson pkgconfig ];
  buildInputs = [ zlib rocksdb rapidjson ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DROCKSDB_HOME=${rocksdb}"
    "-DRAPIDJSON_HOME=${rapidjson}"
  ];

  meta = with stdenv.lib; {
    description = "Tools for filtering, mapping, and OTU-picking from shotgun genomics data";
    license = licenses.lgpl3;
    platforms = platforms.x86_64;
    homepage = https://bioinfo.lifl.fr/RNA/sortmerna/;
    maintainers = with maintainers; [ luispedro ];
  };
}
