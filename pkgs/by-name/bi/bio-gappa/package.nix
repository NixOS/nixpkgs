{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  autoconf,
  pkg-config,
  libz,
  bzip2,
  xz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bio-gappa";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "lczech";
    repo = "gappa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WV8PO0v+e14tyjEm+xQGveQ0Pslgeh+osEMCqF8mue0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    autoconf
  ];

  buildInputs = [
    libz
    bzip2
    xz
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 ../bin/gappa $out/bin/gappa
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/lczech/gappa";
    description = "Toolkit for analyzing and visualizing phylogenetic (placement) data";
    longDescription = ''
      gappa is a collection of commands for working with phylogenetic data. Its
      main focus are evolutionary placements of short environmental sequences
      on a reference phylogenetic tree. Such data are typically produced by
      tools such as EPA-ng, RAxML-EPA or pplacer, and usually stored in jplace
      files.
    '';
    platforms = platforms.all;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bzizou ];
    mainProgram = "gappa";
  };
})
