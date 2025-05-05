{
  lib,
  stdenv,
  fetchFromGitHub,
  mongoc,
  openssl,
  cyrus_sasl,
  cmake,
  validatePkgConfig,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mongocxx";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongo-cxx-driver";
    tag = "r${finalAttrs.version}";
    hash = "sha256-fAOOQyXJ6H4Rt8gRGJnvb5I7E505MOAjNDcFqXUdY+U=";
  };

  postPatch = ''
    substituteInPlace src/bsoncxx/cmake/libbsoncxx.pc.in \
      src/mongocxx/cmake/libmongocxx.pc.in \
      --replace "\''${prefix}/" ""
  '';

  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];

  buildInputs = [
    mongoc
    openssl
    cyrus_sasl
  ];

  cmakeFlags = [
    "-DCMAKE_CXX_STANDARD=20"
    "-DBUILD_VERSION=${finalAttrs.version}"
    "-DENABLE_UNINSTALL=OFF"
  ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "Official C++ client library for MongoDB";
    homepage = "http://mongocxx.org";
    license = licenses.asl20;
    maintainers = with maintainers; [
      adriandole
      vcele
    ];
    pkgConfigModules = [
      "libmongocxx"
      "libbsoncxx"
    ];
    platforms = platforms.all;
    badPlatforms = [ "x86_64-darwin" ]; # needs sdk >= 10.14
  };
})
