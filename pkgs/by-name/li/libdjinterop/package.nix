{ lib
, stdenv
, fetchFromGitHub
, boost
, cmake
, ninja
, pkg-config
, sqlite
, zlib
}:

stdenv.mkDerivation {
  name = "libdjinterop";

  version = "unstable";

  src = fetchFromGitHub {
    owner = "xsco";
    repo = "libdjinterop";
    rev = "0.20.2";
    hash = "sha256-eTr9ax/bZWazLhLLQG6XUgqiM+7LVieh5ruA0EaUaj0=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  outputs = [ "out" "dev" ];

  buildInputs = [
    boost
    sqlite
    zlib
  ];

  meta = with lib; {
    homepage = "https://github.com/xsco/libdjinterop";
    description = "C++ library for access to DJ record libraries";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
