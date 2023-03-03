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
  version = "unstable-2022-12-19";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "wdt";
    rev = "6a122f24deb4f2ff6c6f97b6a803301a7f7b666c";
    sha256 = "sha256-fH4Inqy7DfMJbW1FYWanScLATu8cZA1n+Vas8ee3xwA=";
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
