{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
  testers,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "llhttp";
  version = "9.3.0";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "llhttp";
    tag = "release/v${finalAttrs.version}";
    hash = "sha256-VL58h8sdJIpzMiWNqTvfp8oITjb0b3X/F8ygaE9cH94=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "BUILD_STATIC_LIBS" stdenv.hostPlatform.isStatic)
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=release/v(.+)" ];
  };
  passthru.tests = {
    inherit (python3.pkgs) aiohttp;

    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [ "libllhttp" ];
    };
  };

  meta = {
    description = "Port of http_parser to llparse";
    homepage = "https://llhttp.org/";
    changelog = "https://github.com/nodejs/llhttp/releases/tag/release/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aduh95 ];
    platforms = lib.platforms.all;
  };
})
