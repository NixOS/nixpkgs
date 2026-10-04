{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  eigen,
  gtest,
  nlohmann_json,
  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ale";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "DOI-USGS";
    repo = "ale";
    tag = finalAttrs.version;
    hash = "sha256-XoBTwTwRex8UuKfe/09FlG1zEO8dzM6yN4TJd0PPr80=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  # Both merged after 1.3.0; drop with the next release.
  patches = [
    (fetchpatch {
      url = "https://github.com/DOI-USGS/ale/commit/cec74858266c3057e2c1bcd99d6324a581c26d95.patch";
      excludes = [ "CHANGELOG.md" ];
      hash = "sha256-FRsHXzrWfpxiXtvxfNbRb6JsskbjqvWyr7iN15JH/W0=";
    })
    (fetchpatch {
      url = "https://github.com/DOI-USGS/ale/commit/f4ee48bdb7598eadc8f50e05203eac6e0ae8fa9d.patch";
      excludes = [ "CHANGELOG.md" ];
      hash = "sha256-0A4Bbbt+KxYBTqcAIUMv6zoayuqzlV6jwGgkaYgV4kc=";
    })
  ];

  postPatch = ''
    cat > cmake/gtest.cmake <<EOF
    find_package(GTest REQUIRED)
    add_library(gtest ALIAS GTest::gtest)
    add_library(gmock ALIAS GTest::gmock)
    EOF
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [ eigen ];

  propagatedBuildInputs = [ nlohmann_json ];

  checkInputs = [ gtest ];

  cmakeFlags = [
    # ale::load() needs the Python ale module.
    (lib.cmakeBool "ALE_BUILD_LOAD" false)
    (lib.cmakeBool "ALE_BUILD_DOCS" false)
    (lib.cmakeBool "ALE_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = true;

  passthru = {
    tests.cmake-config = testers.hasCmakeConfigModules {
      moduleNames = [ "ale" ];
      package = finalAttrs.finalPackage;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Abstraction Layer for Ephemerides: position and rotation interpolation for planetary sensor models";
    homepage = "https://github.com/DOI-USGS/ale";
    changelog = "https://github.com/DOI-USGS/ale/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ arunoruto ];
    platforms = lib.platforms.unix;
  };
})
