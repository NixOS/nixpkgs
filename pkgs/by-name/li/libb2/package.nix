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
    rev = "refs/tags/v${finalAttrs.version}";
    sha256 = "0qj8aaqvfcavj1vj5asm4pqm03ap7q8x4c2fy83cqggvky0frgya";
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

  meta = with lib; {
    description = "BLAKE2 family of cryptographic hash functions";
    homepage = "https://blake2.net/";
    pkgConfigModules = [ "libb2" ];
    platforms = platforms.all;
    maintainers = with maintainers; [
      dfoxfranke
      dotlambda
    ];
    license = licenses.cc0;
  };
})
