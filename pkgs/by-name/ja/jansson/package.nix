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
  version = "2.14";

  outputs = [
    "dev"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "akheron";
    repo = "jansson";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FQgy2+g3AyRVJeniqPQj0KNeHgPdza2pmEIXqSyYry4=";
  };

  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];

  cmakeFlags = [
    # networkmanager relies on libjansson.so:
    #   https://github.com/NixOS/nixpkgs/pull/176302#issuecomment-1150239453
    "-DJANSSON_BUILD_SHARED_LIBS=${if stdenv.hostPlatform.isStatic then "OFF" else "ON"}"
  ];

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
