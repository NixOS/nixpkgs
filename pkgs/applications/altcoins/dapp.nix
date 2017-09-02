{ lib, stdenv, fetchFromGitHub, makeWrapper
, seth, git, solc, shellcheck, nodejs, hsevm }:

stdenv.mkDerivation rec {
  name = "dapp";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "dapphub";
    repo = "dapp";
    rev = "v${version}";
    sha256 = "13b2krd02py8jnzjis44lay5i31d95z0myrsy5afzw7fa25giird";
  };

  nativeBuildInputs = [makeWrapper shellcheck];
  buildPhase = "true";
  doCheck = true;
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
