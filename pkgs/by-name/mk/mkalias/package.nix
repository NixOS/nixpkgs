{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  darwin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mkalias";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "vs49688";
    repo = "mkalias";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kIVCtYGlWKS0d/Potwo6X8F7Hgc/1S1RQTEbJi+IL9U=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    darwin.apple_sdk.frameworks.Foundation
  ];

  cmakeFlags = [
    "-DMKALIAS_VERSION=${finalAttrs.version}"
  ];

  installPhase = ''
    runHook preInstall

    install -D mkalias $out/bin/mkalias

    runHook postInstall
  '';

  meta = {
    description = "Quick'n'dirty tool to make APFS aliases";
    homepage = "https://github.com/vs49688/mkalias";
    license = lib.licenses.gpl2Only;
    mainProgram = "mkalias";
    maintainers = with lib.maintainers; [
      zane
      emilytrau
    ];
    platforms = lib.platforms.darwin;
  };
})
