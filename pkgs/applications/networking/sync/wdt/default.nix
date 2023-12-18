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
  version = "unstable-2023-12-01";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "wdt";
    rev = "66f17af009ef6eaf2707bb8bb511ba6bcf3d9bbe";
    sha256 = "sha256-ucnFcpH9Duru35kRT769zMX2BMqufZJopd2srKPJkrU=";
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
