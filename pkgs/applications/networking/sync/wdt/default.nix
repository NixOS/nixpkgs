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
  version = "unstable-2024-02-05";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "wdt";
    rev = "d94b2d5df6f1c803f9f3b8ed9247b752fa853865";
    sha256 = "sha256-9TeJbZZq9uQ6KaEBFGDyIGcXgxi2y1aj55vxv5dAIzw=";
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
    updateScript = unstableGitUpdater { };
  };

  meta = with lib; {
    description = "Warp speed Data Transfer";
    homepage = "https://github.com/facebook/wdt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nickcao ];
    platforms = [ "x86_64-linux" ];
  };
}
