{ stdenv
, lib
, fetchFromGitHub
, cmake
, folly
, boost
, gflags
, glog
, openssl
, double-conversion
, fmt
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "wdt";
  version = "1.27.1612021-unstable-2024-06-26";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "wdt";
    rev = "aab22d7284dbc470df36146a8885335760b47b0c";
    sha256 = "sha256-nWdZfbwAIwyaOMsAE94MrkHHRmwrFyFZRmYno+2/5mQ=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ folly boost gflags glog openssl double-conversion fmt ];

  # source is expected to be named wdt
  # https://github.com/facebook/wdt/blob/43319e59d0c77092468367cdadab37d12d7a2383/CMakeLists.txt#L238
  postUnpack = ''
    ln -s $sourceRoot wdt
  '';

  cmakeFlags = [
    "-DWDT_USE_SYSTEM_FOLLY=ON"
  ];

  passthru = {
    updateScript = unstableGitUpdater {
      tagPrefix = "v";
    };
  };

  meta = with lib; {
    description = "Warp speed Data Transfer";
    homepage = "https://github.com/facebook/wdt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nickcao ];
    platforms = [ "x86_64-linux" ];
  };
}
