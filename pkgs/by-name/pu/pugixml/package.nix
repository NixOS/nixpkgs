{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  check,
  validatePkgConfig,
  shared ? false,
}:

stdenv.mkDerivation rec {
  pname = "pugixml";
  version = "1.15";

  src = fetchFromGitHub {
    owner = "zeux";
    repo = "pugixml";
    tag = "v${version}";
    hash = "sha256-t/57lg32KgKPc7qRGQtO/GOwHRqoj78lllSaE/A8Z9Q=";
  };

  outputs = [ "out" ] ++ lib.optionals shared [ "dev" ];

  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTS" true)
    (lib.cmakeBool "BUILD_SHARED_LIBS" shared)
  ];

  nativeCheckInputs = [ check ];

  preConfigure = ''
    # Enable long long support (required for filezilla)
    sed -i -e '/PUGIXML_HAS_LONG_LONG/ s/^\/\///' src/pugiconfig.hpp
  '';

  meta = {
    description = "Light-weight, simple and fast XML parser for C++ with XPath support";
    homepage = "https://pugixml.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pSub ];
    platforms = lib.platforms.unix;
  };
}
