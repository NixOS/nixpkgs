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
  version = "0.7.2";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Thalhammer";
    repo = "jwt-cpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jzxK21mc7M6+ozxLo5KCqb7A/6gLWNaim5/UC7kZqHE=";
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
