{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  which,
  ldc,
  zlib,
  lz4,
}:

stdenv.mkDerivation rec {
  pname = "sambamba";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "biod";
    repo = "sambamba";
    rev = "v${version}";
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

  buildFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  # Upstream's install target is broken; copy manually
  installPhase = ''
    runHook preInstall

    install -Dm755 bin/sambamba-${version} $out/bin/sambamba

    runHook postInstall
  '';

  meta = with lib; {
    description = "SAM/BAM processing tool";
    mainProgram = "sambamba";
    homepage = "https://lomereiter.github.io/sambamba/";
    maintainers = with maintainers; [ jbedo ];
    license = with licenses; gpl2;
    platforms = platforms.x86_64;
  };
}
