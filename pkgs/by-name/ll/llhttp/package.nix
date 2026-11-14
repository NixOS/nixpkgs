{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
  testers,
  python3,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "llhttp";
  version = "9.4.4";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "llhttp";
    tag = "release/v${finalAttrs.version}";
    hash = "sha256-ZJVC37wbsZ7DbqtiaQqe1EVYTsR7tNxXUQT5L8rbACo=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "LLHTTP_BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "LLHTTP_BUILD_STATIC_LIBS" stdenv.hostPlatform.isStatic)
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=release/v(.+)" ];
  };
  passthru.tests = {
    inherit (python3.pkgs) aiohttp;

    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  __structuredAttrs = true;

  meta = {
    description = "Port of http_parser to llparse";
    homepage = "https://llhttp.org/";
    changelog = "https://github.com/nodejs/llhttp/releases/tag/release/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aduh95 ];
    platforms = lib.platforms.all;
    pkgConfigModules = [ "libllhttp" ];
  };
})
