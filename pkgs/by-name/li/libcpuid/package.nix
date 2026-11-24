{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcpuid";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "anrieff";
    repo = "libcpuid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+/TTlGk1ePPTHrSTSZmPHT2h3gKs9ouCF4ElvLWHF/g=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  strictDeps = true;

  outputs = [
    "out"
    "dev"
  ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  __structuredAttrs = true;

  meta = {
    homepage = "https://libcpuid.sourceforge.net/";
    description = "Small C library for CPU detection and feature extraction";
    mainProgram = "cpuid_tool";
    changelog = "https://raw.githubusercontent.com/anrieff/libcpuid/master/ChangeLog";
    license = lib.licenses.bsd2;
    maintainers = [
    ];
    platforms = lib.platforms.x86 ++ lib.platforms.arm ++ lib.platforms.aarch64;
    pkgConfigModules = [ "libcpuid" ];
  };
})
