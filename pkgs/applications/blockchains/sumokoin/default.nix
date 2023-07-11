{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, boost
, openssl
, libsodium
, libunwind
, lmdb
, unbound
, zeromq
}:

stdenv.mkDerivation rec {
  pname = "sumokoin";
  version = "0.8.1.0";

  src = fetchFromGitHub {
    owner = "sumoprojects";
    repo = "sumokoin";
    rev = "v${version}";
    hash = "sha256-CHZ6hh60U6mSR68CYDKMWTYyX1koF4gA7YrA1P5f0Dk=";
  };

  # disable POST_BUILD
  postPatch = ''
    sed -i 's/if (UNIX)/if (0)/g' src/utilities/*_utilities/CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    openssl
    libsodium
    libunwind
    lmdb
    unbound
    zeromq
  ];

  # cc1: error: '-Wformat-security' ignored without '-Wformat' [-Werror=format-security]
  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "A fork of Monero and a truely fungible cryptocurrency";
    homepage = "https://www.sumokoin.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.linux;
  };
}
