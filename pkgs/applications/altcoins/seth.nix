{ stdenv, makeWrapper, lib, fetchFromGitHub
, bc, coreutils, curl, ethabi, git, gnused, jshon, perl, solc, which
, nodejs, ethsign
}:

stdenv.mkDerivation rec {
  name = "seth-${version}";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "dapphub";
    repo = "seth";
    rev = "v${version}";
    sha256 = "0la2nfqsscpbq6zwa6hsd73nimdnrhilrmgyy77yr3jca2wjhsjk";
  };

  nativeBuildInputs = [makeWrapper];
  buildPhase = "true";
  makeFlags = ["prefix=$(out)"];
  postInstall = let path = lib.makeBinPath [
    bc coreutils curl ethabi git gnused jshon perl solc which nodejs ethsign
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
