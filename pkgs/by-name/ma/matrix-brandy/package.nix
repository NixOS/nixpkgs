{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  nix-update-script,
  SDL,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "matrix-brandy";
  version = "1.23.5";

  src = fetchFromGitHub {
    owner = "stardot";
    repo = "MatrixBrandy";
    rev = "V${finalAttrs.version}";
    hash = "sha256-sMgYgV4/vV1x5xSICXRpW6K8uCdVlJrS7iEg6XzQRo8=";
  };

  patches = lib.optionals stdenv.hostPlatform.isDarwin [ ./no-lrt.patch ];

  makeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "CC=cc"
    "LD=clang"
  ];

  buildInputs = [
    libX11
    SDL
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp brandy $out/bin
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://brandy.matrixnetwork.co.uk/";
    description = "Matrix Brandy BASIC VI for Linux, Windows, MacOSX";
    mainProgram = "brandy";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fiq ];
  };
})
