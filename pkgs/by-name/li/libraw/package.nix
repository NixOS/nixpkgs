{
  lib,
  stdenv,
  testers,
  fetchFromGitHub,
  autoreconfHook,
  lcms2,
  pkg-config,

  # for passthru.tests
  hdrmerge,
  imagemagick,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libraw";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "LibRaw";
    repo = "LibRaw";
    tag = finalAttrs.version;
    hash = "sha256-1Q2u9v1yOzXchUGvZvbLKk506xATjMb421H2sBZURZs=";
  };

  outputs = [
    "out"
    "lib"
    "dev"
    "doc"
  ];

  propagatedBuildInputs = [ lcms2 ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  enableParallelBuilding = true;

  postPatch = lib.optionalString stdenv.hostPlatform.isFreeBSD ''
    substituteInPlace libraw*.pc.in --replace-fail -lstdc++ ""
  '';

  passthru.tests = {
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    inherit imagemagick hdrmerge;
    inherit (python3.pkgs) rawkit;
  };

  meta = {
    description = "Library for reading RAW files obtained from digital photo cameras (CRW/CR2, NEF, RAF, DNG, and others)";
    homepage = "https://www.libraw.org/";
    changelog = "https://www.libraw.org/download#changelog";
    license = with lib.licenses; [
      cddl
      lgpl2Plus
    ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [
      "libraw"
      "libraw_r"
    ];
  };
})
