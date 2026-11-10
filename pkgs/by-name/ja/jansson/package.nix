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
  version = "2.15.1";

  outputs = [
    "dev"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "akheron";
    repo = "jansson";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iOOZyrNlCbibT7qozH7B2RjAgG9yv+B2ldAaz8U6IhQ=";
  };

  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];

  strictDeps = true;

  cmakeFlags = [
    # networkmanager relies on libjansson.so:
    #   https://github.com/NixOS/nixpkgs/pull/176302#issuecomment-1150239453
    (lib.cmakeBool "JANSSON_BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
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

  __structuredAttrs = true;

  meta = {
    description = "C library for encoding, decoding and manipulating JSON data";
    homepage = "https://github.com/akheron/jansson";
    changelog = "https://github.com/akheron/jansson/raw/${finalAttrs.src.tag}/CHANGES";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    platforms = lib.platforms.all;
    pkgConfigModules = [ "jansson" ];
  };
})
