{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libtool,
  pkg-config,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libb2";
  version = "0.98.1";

  src = fetchFromGitHub {
    owner = "BLAKE2";
    repo = "libb2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yr/sgJ/7PcwG8k4w0hE+Vw1Q8SVVqyJ3kFsxt7FSSGI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    libtool
    pkg-config
  ];

  configureFlags = lib.optional stdenv.hostPlatform.isx86 "--enable-fat=yes";

  enableParallelBuilding = true;

  doCheck = true;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "BLAKE2 family of cryptographic hash functions";
    homepage = "https://blake2.net/";
    pkgConfigModules = [ "libb2" ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      dfoxfranke
      dotlambda
    ];
    license = lib.licenses.cc0;
  };
})
