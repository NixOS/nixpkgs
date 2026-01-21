{
  lib,
  stdenv,
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
  version = "0.21.5b";

  src = fetchFromGitHub {
    owner = "LibRaw";
    repo = "LibRaw";
    tag = finalAttrs.version;
    hash = "sha256-CE7XB61bnjRhy0Ww2Q3pvvSJMobHHta5jn4F/i/oOEE=";
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
    inherit imagemagick hdrmerge;
    inherit (python3.pkgs) rawkit;
  };

  meta = {
    description = "Library for reading RAW files obtained from digital photo cameras (CRW/CR2, NEF, RAF, DNG, and others)";
    homepage = "https://www.libraw.org/";
    license = with lib.licenses; [
      cddl
      lgpl2Plus
    ];
    platforms = lib.platforms.unix;
  };
})
