{ stdenv, lib, fetchFromGitHub, cmake, folly, boost, gflags, glog, openssl, double-conversion, fmt }:

stdenv.mkDerivation {
  pname = "wdt";
  version = "unstable-2022-03-24";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "wdt";
    rev = "43319e59d0c77092468367cdadab37d12d7a2383";
    sha256 = "sha256-MajYK2eTUbWhEql0iTlgW5yLg9xAGZQk+Dx4fNxFFqw=";
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

  meta = with lib; {
    description = "Warp speed Data Transfer";
    homepage = "https://github.com/facebook/wdt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nickcao ];
    platforms = [ "x86_64-linux" ];
  };
}
