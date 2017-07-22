{ lib, stdenv, fetchFromGitHub, makeWrapper
, seth, git, solc, shellcheck, nodejs, hsevm }:

stdenv.mkDerivation rec {
  name = "dapp";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "dapphub";
    repo = "dapp";
    rev = "v${version}";
    sha256 = "1529ml5r1l5g6xcak7k3h3ih214mgnk87jsxyk0rvk245jkard1y";
  };

  nativeBuildInputs = [makeWrapper shellcheck];
  buildPhase = "true";
  doCheck = false;
  checkPhase = "make test";
  makeFlags = ["prefix=$(out)"];
  postInstall = let path = lib.makeBinPath [
    nodejs solc git seth hsevm
  ]; in ''
    wrapProgram "$out/bin/dapp" --prefix PATH : "${path}"
  '';

  meta = {
    description = "Simple tool for creating Ethereum-based dapps";
    homepage = https://github.com/dapphub/dapp/;
    maintainers = [stdenv.lib.maintainers.dbrock];
    license = lib.licenses.gpl3;
    inherit version;
  };
}
