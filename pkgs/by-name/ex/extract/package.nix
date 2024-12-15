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
    rev = "v1.0.0";
    hash = "sha256-Zk4DGs/KZXr1CJ4VKJGqru4SM5eXHh5m5NbOuoAhZeE=";
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
  installPhase = "install -D -m 755 ${src}/ex -t $out/bin";
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
