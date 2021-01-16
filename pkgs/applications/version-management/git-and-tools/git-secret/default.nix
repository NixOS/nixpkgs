{ stdenv, lib, fetchFromGitHub, makeWrapper, git, gnupg, gawk }:

let
  version = "0.3.3";
  repo = "git-secret";

in stdenv.mkDerivation {
  name = "${repo}-${version}";

  src = fetchFromGitHub {
    inherit repo;
    owner = "sobolevn";
    rev = "v${version}";
    sha256 = "0hc7yavcp8jmn6b7wngjqhy8kl7f4191sfpik8ycvqghkvvimxj4";
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
    homepage = "https://git-secret.io";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lo1tuma ];
    platforms = lib.platforms.all;
  };
}
