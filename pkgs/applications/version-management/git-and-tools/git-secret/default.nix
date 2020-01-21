{ stdenv, lib, fetchFromGitHub, makeWrapper, git, gnupg, gawk }:

let
  version = "0.3.2";
  repo = "git-secret";

in stdenv.mkDerivation {
  name = "${repo}-${version}";

  src = fetchFromGitHub {
    inherit repo;
    owner = "sobolevn";
    rev = "v${version}";
    sha256 = "0n268xlsd9p5f083sqwzpvsqg99fdk876mf8gihkydakrismc45b";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    install -D git-secret $out/bin/git-secret

    wrapProgram $out/bin/git-secret \
      --prefix PATH : "${lib.makeBinPath [ git gnupg gawk ]}"

    mkdir $out/share
    cp -r man $out/share
  '';

  meta = {
    description = "A bash-tool to store your private data inside a git repository";
    homepage = https://git-secret.io;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.lo1tuma ];
    platforms = stdenv.lib.platforms.all;
  };
}
