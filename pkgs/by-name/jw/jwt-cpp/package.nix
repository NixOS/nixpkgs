{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  nlohmann_json,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jwt-cpp";
  version = "0.7.3";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Thalhammer";
    repo = "jwt-cpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mRvtyw32Rv0xrrmX4VaAmyyZ1BDI9aV4O8PefCrbxJk=";
  };

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [
    openssl
    nlohmann_json
  ];

  cmakeFlags = [
    (lib.cmakeBool "JWT_BUILD_EXAMPLES" false)
    (lib.cmakeBool "JWT_DISABLE_PICOJSON" true)
    (lib.cmakeFeature "JWT_CMAKE_FILES_INSTALL_DIR" "lib/cmake/jwt-cpp")
  ];

  passthru.tests.cmake-config = testers.hasCmakeConfigModules {
    moduleNames = [ "jwt-cpp" ];
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Header-only C++ library for creating and validating JSON Web Tokens";
    homepage = "https://github.com/Thalhammer/jwt-cpp";
    changelog = "https://github.com/Thalhammer/jwt-cpp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    platforms = lib.platforms.unix;
  };
})
