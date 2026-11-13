{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
  nix-update-script,
  SDL,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "matrix-brandy";
  version = "1.23.6";

  src = fetchFromGitHub {
    owner = "stardot";
    repo = "MatrixBrandy";
    rev = "V${finalAttrs.version}";
    hash = "sha256-Cyr3nfX8JHf8udTMQKTHy4sNVkSRjtScye6yUffLXHI=";
  };

  patches = lib.optionals stdenv.hostPlatform.isDarwin [ ./no-lrt.patch ];

  makeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "CC=cc"
    "LD=clang"
  ];

  buildInputs = [
    libx11
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
