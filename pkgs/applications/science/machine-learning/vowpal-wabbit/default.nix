{ lib, stdenv, fetchFromGitHub, cmake, boost169, flatbuffers, fmt, rapidjson, spdlog, zlib }:

stdenv.mkDerivation rec {
  pname = "vowpal-wabbit";
  version = "8.10.0";

  src = fetchFromGitHub {
    owner = "VowpalWabbit";
    repo = "vowpal_wabbit";
    rev = version;
    sha256 = "1vxnwanflsx6zf8m9mrxms28ii7rl61xfxp3556y3iawmy11d6pl";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost169
    flatbuffers
    fmt
    rapidjson
    spdlog
    zlib
  ];

  # -DBUILD_TESTS=OFF is set as both it saves time in the build and the default
  # cmake flags appended by the builder include -DBUILD_TESTING=OFF for which
  # this is the equivalent flag.
  # Flatbuffers are an optional feature.
  # BUILD_FLATBUFFERS=ON turns it on. This will still consume Flatbuffers as a
  # system dependency
  cmakeFlags = [
    "-DVW_INSTALL=ON"
    "-DBUILD_TESTS=OFF"
    "-DBUILD_JAVA=OFF"
    "-DBUILD_PYTHON=OFF"
    "-DUSE_LATEST_STD=ON"
    "-DRAPIDJSON_SYS_DEP=ON"
    "-DFMT_SYS_DEP=ON"
    "-DSPDLOG_SYS_DEP=ON"
    "-DBUILD_FLATBUFFERS=ON"
  ];

  meta = with lib; {
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
