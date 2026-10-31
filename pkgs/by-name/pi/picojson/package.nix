{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "picojson";
  version = "0-unstable-2022-12-19";

  strictDeps = true;
  __structuredAttrs = true;
  separateDebugInfo = true;

  src = fetchFromGitHub {
    owner = "tristanpenman";
    repo = "picojson";
    rev = "9dfda04e89c28a9e602ce9ef626dd9b6acbc6e60";
    hash = "sha256-rJXvTKqLg0a3YKpMCmQ3JalrHdKUnV+4dsSrariitkE=";
  };

  # Header-only; upstream's own Makefile only installs the header, and ships
  # no CMake config of any kind (find_package() consumers, e.g. valijson,
  # need one).
  dontBuild = true;

  doCheck = true;
  checkTarget = "check";

  installPhase = ''
    runHook preInstall

    install -Dm644 picojson.h -t $out/include

    mkdir -p $out/lib/cmake/picojson
    substitute ${./cmake/picojsonConfig.cmake.in} $out/lib/cmake/picojson/picojson-config.cmake \
      --subst-var out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "tristanpenman's continuation fork of kazuho/picojson, a single-header C++ JSON parser/serializer";
    homepage = "https://github.com/tristanpenman/picojson";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
