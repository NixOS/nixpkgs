{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  zlib,
}:
stdenv.mkDerivation {
  pname = "imgdataopt";
  version = "0-unstable-2023-04-18";

  src = fetchFromGitHub {
    owner = "pts";
    repo = "imgdataopt";
    rev = "5906ee33826d090e470889b82fdac8f1a0e7c673";
    hash = "sha256-Fd2mQLVzx2PdWlPFDCTz4PsBPgMbB8X7DkCvGKoCMwc=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "CC = gcc" ""
  '';

  buildInputs = [ zlib ];

  makeFlags = [ "imgdataopt.lz" ];

  installPhase = ''
    runHook preInstall
    install -Dm0755 imgdataopt.lz $out/bin/imgdataopt
    runHook postInstall
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "A command-line tool that converts PNG and PNM raster (bitmap) image formats to each other, doing some lossless size optimizations";
    homepage = "https://github.com/pts/imgdataopt";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jwillikers ];
    mainProgram = "imgdataopt";
  };
}
