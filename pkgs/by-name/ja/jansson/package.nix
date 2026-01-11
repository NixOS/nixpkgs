{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
  testers,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jansson";
  version = "2.14.1";

  outputs = [
    "dev"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "akheron";
    repo = "jansson";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ct/EzRDrHkZrCcm98XGCbjbOM2h3AAMldPoTWA5+dAE=";
  };

  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];

  cmakeFlags = [
    # networkmanager relies on libjansson.so:
    #   https://github.com/NixOS/nixpkgs/pull/176302#issuecomment-1150239453
    "-DJANSSON_BUILD_SHARED_LIBS=${if stdenv.hostPlatform.isStatic then "OFF" else "ON"}"

    # Fix the build with CMake 4.
    #
    # Remove on next release; upstream fix is coupled with additional
    # changes in <https://github.com/akheron/jansson/pull/692>.
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.10"
  ];

  postFixup = ''
    # Incorrectly references the dev output, libjansson.so is in out
    substituteInPlace $dev/lib/cmake/jansson/janssonTargets-release.cmake \
      --replace-fail "\''${_IMPORT_PREFIX}/lib" "$out/lib"
  '';

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "C library for encoding, decoding and manipulating JSON data";
    homepage = "https://github.com/akheron/jansson";
    changelog = "https://github.com/akheron/jansson/raw/${finalAttrs.src.rev}/CHANGES";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    platforms = lib.platforms.all;
    pkgConfigModules = [ "jansson" ];
  };
})
