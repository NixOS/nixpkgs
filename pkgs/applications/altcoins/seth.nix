{ stdenv, makeWrapper, lib, fetchFromGitHub
, bc, coreutils, curl, ethabi, git, gnused, jshon, solc, which }:

stdenv.mkDerivation rec {
  name = "seth-${version}";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "dapphub";
    repo = "seth";
    rev = "v${version}";
    sha256 = "1qph1gldj24r8l6aswb1w133lrm8zsxmmxl4krjik0a73bm4ghdm";
  };

  nativeBuildInputs = [makeWrapper];
  buildPhase = "true";
  makeFlags = ["prefix=$(out)"];
  postInstall = let path = lib.makeBinPath [
    bc coreutils curl ethabi git gnused jshon solc which
  ]; in ''
    wrapProgram "$out/bin/seth" --prefix PATH : "${path}"
  '';

  meta = {
    description = "Command-line client for talking to Ethereum nodes";
    homepage = https://github.com/dapphub/seth/;
    maintainers = [stdenv.lib.maintainers.dbrock];
    license = lib.licenses.gpl3;
    inherit version;
  };
}
