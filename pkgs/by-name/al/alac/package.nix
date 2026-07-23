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
  version = "0.0.7-unstable-2024-10-16";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "mikebrady";
    repo = "alac";
    rev = "1832544d27d01335d823d639b176d1cae25ecfd4";
    hash = "sha256-xRWDeqyJ/BEaSWVlDXgaKIKJuBwM8kJDIATVTVaMn2k=";
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
