{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "acc";
  version = "1.60";

  src = fetchFromGitHub {
    owner = "zdoom";
    repo = "acc";
    rev = finalAttrs.version;
    hash = "sha256-HGF4O4LcMDY4f/ZuBbkvx5Wd86+8Ict624eKTJ88/rQ=";
  };

  patches = [
    # Don't force static builds
    ./disable-static.patch
  ];

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    runHook preInstall

    install -D acc $out/bin/acc

    runHook postInstall
  '';

  meta = {
    description = "ACS script compiler for use with ZDoom and Hexen";
    homepage = "https://zdoom.org/wiki/ACC";
    license = lib.licenses.activision;
    maintainers = with lib.maintainers; [ emilytrau ];
    platforms = lib.platforms.all;
    mainProgram = "acc";
  };
})
