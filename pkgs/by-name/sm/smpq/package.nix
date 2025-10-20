{
  lib,
  cmake,
  fetchFromGitHub,
  fetchurl,
  stdenv,
  stormlib,
}:

let
  stormlib_9_22 = stormlib.overrideAttrs (old: {
    version = "9.22";
    src = fetchFromGitHub {
      owner = "ladislav-zezula";
      repo = "StormLib";
      rev = "v9.22";
      hash = "sha256-jFUfxLzuRHAvFE+q19i6HfGcL6GX4vKL1g7l7LOhjeU=";
    };
  });
in

stdenv.mkDerivation (finalAttrs: {
  pname = "smpq";
  version = "1.6";

  src = fetchurl {
    url = "https://launchpad.net/smpq/trunk/${finalAttrs.version}/+download/smpq_${finalAttrs.version}.orig.tar.gz";
    hash = "sha256-tdLcil3oYptx7l02ErboTYhBi4bFzTm6MV6esEYvGMs=";
  };

  cmakeFlags = [
    (lib.cmakeBool "WITH_KDE" false)
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ stormlib_9_22 ];

  strictDeps = true;

  meta = {
    homepage = "https://launchpad.net/smpq";
    description = "StormLib MPQ archiving utility";
    license = lib.licenses.gpl3Only;
    mainProgram = "smpq";
    maintainers = with lib.maintainers; [
      aanderse
    ];
    platforms = lib.platforms.all;
  };
})
