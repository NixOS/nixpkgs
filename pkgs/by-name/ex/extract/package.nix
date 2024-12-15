{
  fetchFromGitHub,
  gnutar,
  gzip,
  lib,
  libarchive,
  p7zip,
  stdenv,
  unzip,
  zstd,
}:
let
  src = fetchFromGitHub {
    owner = "NewDawn0";
    repo = "ex";
    rev = "136389950b0f60de5c84b5535663c237da7f0908";
    hash = "sha256-XDCBlaWTreKd3R10njsrhv7j0/OIsco7tcFjeG85mpE=";
  };
in
stdenv.mkDerivation {
  pname = "ex";
  version = "1.0.0";
  inherit src;
  propagatedBuildInputs = [
    gnutar
    gzip
    libarchive
    p7zip
    unzip
    zstd
  ];
  installPhase = ''
    mkdir -p "$out/bin";
    cp "${src}/ex" $out/bin/ex
  '';
  meta = {
    description = "A command-line wrapper for extracting common archive formats";
    longDescription = ''
      This tool wraps around popular archive extraction commands, providing a simple interface to extract files from formats like ZIP, TAR, and more.
      It streamlines file extraction for most pouplar archive formats.
    '';
    homepage = "https://github.com/NewDawn0/ex";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NewDawn0 ];
    platforms = lib.platforms.all;
  };
}
