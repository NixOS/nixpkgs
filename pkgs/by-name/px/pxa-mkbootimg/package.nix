{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "pxa-mkbootimg";
  version = "2022.11.09";

  src = fetchFromGitHub {
    owner = "osm0sis";
    repo = "pxa-mkbootimg";
    rev = finalAttrs.version;
    hash = "sha256-CZxtTPUlbUNsYTdNK0UYhlU45rYy4ToODE00MGlOPb0=";
  };

  strictDeps = true;

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optional stdenv.cc.isGNU [
      # Required with newer GCC
      "-Wno-error=stringop-overflow"
    ]
  );

  # Upstream has an install target, but doesn't install all required binaries
  installPhase = ''
    runHook preInstall
    install -Dm555 -t $out/bin {pxa-mkbootimg,pxa-unpackbootimg,pxa1088-dtbtool,pxa1908-dtbtool}
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/osm0sis/pxa-mkbootimg";
    description = "Boot image tool variants for the Marvell PXA1088 and PXA1908 boards";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "pxa-mkbootimg";
  };
})
