{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  nix-update-script,
  SDL,
}:

stdenv.mkDerivation rec {
  pname = "matrix-brandy";
  version = "1.23.5";

  src = fetchFromGitHub {
    owner = "stardot";
    repo = "MatrixBrandy";
    rev = "V${version}";
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

  meta = with lib; {
    homepage = "https://brandy.matrixnetwork.co.uk/";
    description = "Matrix Brandy BASIC VI for Linux, Windows, MacOSX";
    mainProgram = "brandy";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fiq ];
  };
}
