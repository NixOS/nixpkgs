{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  python3,
  which,
  ldc,
  zlib,
  lz4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sambamba";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "biod";
    repo = "sambamba";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3O9bHGpMuCgdR2Wm7Dv1VUjMT1QTn8K1hdwgjvwhFDw=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    which
    python3
    ldc
  ];
  buildInputs = [
    zlib
    lz4
  ];

  patches = [
    # remove on next release; add missing break
    (fetchpatch {
      url = "https://github.com/biod/sambamba/commit/5fdcf6f3015cb17b805514397223f7513bc92613.patch";
      hash = "sha256-9iJmR9rJgGKH1kSFTnUCqZ4IU+Xz923SIloeBiYmIk4=";
    })
  ];

  buildFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  # Upstream's install target is broken; copy manually
  installPhase = ''
    runHook preInstall

    install -Dm755 bin/sambamba-${finalAttrs.version} $out/bin/sambamba

    runHook postInstall
  '';

  meta = {
    description = "SAM/BAM processing tool";
    mainProgram = "sambamba";
    homepage = "https://lomereiter.github.io/sambamba/";
    maintainers = with lib.maintainers; [ jbedo ];
    license = with lib.licenses; gpl2;
    platforms = lib.platforms.x86_64;
  };
})
