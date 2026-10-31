{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "json11";
  version = "0-unstable-2021-01-04";

  strictDeps = true;
  __structuredAttrs = true;
  separateDebugInfo = true;

  src = fetchFromGitHub {
    owner = "dropbox";
    repo = "json11";
    rev = "2df9473fb3605980db55ecddf34392a2e832ad35";
    hash = "sha256-NHWlkCz6PpBN7FNluVm64GYfjAV25BPjZWkRERtVsGg=";
  };

  # json11.cpp uses uint8_t without including <cstdint>, relying on it being
  # pulled in transitively - no longer true with newer libstdc++. TODO: Upstream.
  patches = [ ./missing-cstdint-include.patch ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "JSON11_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  # json11_test is built (JSON11_BUILD_TESTS) but never registered via
  # add_test() upstream, so there's nothing for ctest to run.
  checkPhase = ''
    runHook preCheck
    ./json11_test
    runHook postCheck
  '';

  # Upstream's own CMakeLists.txt installs the library/header but exports no
  # CMake package-config (find_package() consumers, e.g. valijson, need one).
  postInstall =
    let
      libSuffix =
        if !stdenv.hostPlatform.isStatic then
          stdenv.hostPlatform.extensions.sharedLibrary
        else
          stdenv.hostPlatform.extensions.staticLibrary;
    in
    ''
      mkdir -p $out/lib/cmake/json11
      substitute ${./cmake/json11Config.cmake.in} $out/lib/cmake/json11/json11-config.cmake \
        --subst-var out \
        --subst-var-by libSuffix "${libSuffix}"
    '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Tiny JSON library for C++11";
    homepage = "https://github.com/dropbox/json11";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
