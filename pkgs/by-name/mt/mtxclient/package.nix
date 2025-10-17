{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  coeurl,
  curl,
  libevent,
  nlohmann_json,
  olm,
  openssl,
  re2,
  spdlog,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mtxclient";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "Nheko-Reborn";
    repo = "mtxclient";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Y0FMCq4crSbm0tJtYq04ZFwWw+vlfxXKXBo0XUgf7hw=";
  };

  patches = [
    ./remove-network-tests.patch
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_LIB_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "BUILD_LIB_EXAMPLES" false)
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    coeurl
    curl
    libevent
    nlohmann_json
    olm
    openssl
    re2
    spdlog
  ];

  checkInputs = [ gtest ];

  doCheck = true;

  meta = with lib; {
    description = "Client API library for the Matrix protocol";
    homepage = "https://github.com/Nheko-Reborn/mtxclient";
    license = licenses.mit;
    maintainers = with maintainers; [
      fpletz
      pstn
      rebmit
      rnhmjoj
    ];
    platforms = platforms.all;
  };
})
