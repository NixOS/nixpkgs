{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  boost,
  openssl,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "asio";
  version = "1.34.2";

  src = fetchFromGitHub {
    owner = "chriskohlhoff";
    repo = "asio";
    tag = "asio-${lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version}";
    hash = "sha256-B9tFXcmBn7n4wEdnfjw5o90fC/cG5+WMdu/K4T6Y+jI=";
  };

  sourceRoot = "${finalAttrs.src.name}/asio";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs = [ boost ];

  buildInputs = [ openssl ];

  enableParallelBuilding = true;

  doCheck = true;

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
    versionCheck = true;
  };

  meta = {
    homepage = "https://think-async.com/Asio";
    description = "Cross-platform C++ library for network and low-level I/O programming";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "asio" ];
  };
})
