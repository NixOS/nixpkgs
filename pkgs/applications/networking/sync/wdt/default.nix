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
  version = "unstable-2022-07-08";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "wdt";
    rev = "8f01b7558a80e5f08b06244d2821c3eb5c1d6e9b";
    sha256 = "sha256-ozii7EA3j3F/o+lE2mPsUY5lrm3OOtK75gjGkrvoaQ0=";
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
