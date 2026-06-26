{
  autoreconfHook,
  fetchFromGitHub,
  lib,
  stdenv,
  testers,
  unstableGitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "alac";
  version = "0.0.7-unstable-2026-04-10";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "mikebrady";
    repo = "alac";
    rev = "5d8c5db0dfcadd5872f28e665cf4f4303447352a";
    hash = "sha256-Wb6I5YHGvBVjVgOutICbRKH96odR3ZgmNS6HQedVahk=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  passthru = {
    updateScript = unstableGitUpdater { };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Apple Lossless Codec and Utility with Autotools";
    homepage = "https://github.com/mikebrady/alac";
    license = lib.licenses.asl20;
    pkgConfigModules = [ "alac" ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
})
