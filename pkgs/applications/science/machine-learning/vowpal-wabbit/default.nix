{ lib, stdenv, fetchFromGitHub, cmake, boost169, rapidjson, zlib }:

stdenv.mkDerivation rec {
  pname = "vowpal-wabbit";
  version = "8.9.2";

  src = fetchFromGitHub {
    owner = "VowpalWabbit";
    repo = "vowpal_wabbit";
    rev = version;
    sha256 = "0ng1kip7sh3br85691xvszxd6lhv8nhfkgqkpwxd89wy85znzhmd";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost169
    rapidjson
    zlib
  ];

  # -DBUILD_TESTS=OFF is set as both it saves time in the build and the default
  # cmake flags appended by the builder include -DBUILD_TESTING=OFF for which
  # this is the equivalent flag.
  cmakeFlags = [
    "-DVW_INSTALL=ON"
    "-DBUILD_TESTS=OFF"
    "-DBUILD_JAVA=OFF"
    "-DBUILD_PYTHON=OFF"
    "-DUSE_LATEST_STD=ON"
    "-DRAPIDJSON_SYS_DEP=ON"
  ];

  meta = with lib; {
    broken = stdenv.isAarch32 || stdenv.isAarch64;
    description = "Machine learning system focused on online reinforcement learning";
    homepage = "https://github.com/VowpalWabbit/vowpal_wabbit/";
    license = licenses.bsd3;
    longDescription = ''
      Machine learning system which pushes the frontier of machine learning with techniques such as online,
      hashing, allreduce, reductions, learning2search, active, and interactive and reinforcement learning
    '';
    maintainers = with maintainers; [ jackgerrits ];
    platforms = platforms.unix;
  };
}
