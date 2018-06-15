{ stdenv, lib, fetchFromGitHub, makeWrapper, git }:

let
  version = "1.2.1";
  repo = "git-secrets";

in stdenv.mkDerivation {
  name = "${repo}-${version}";

  src = fetchFromGitHub {
    inherit repo;
    owner = "awslabs";
    rev = "${version}";
    sha256 = "14jsm4ks3k5d9iq3jr23829izw040pqpmv7dz8fhmvx6qz8fybzg";
  };

  buildInputs = [ makeWrapper git];

  # buildPhase = ''
  #  make man # TODO: need rst2man.py
  # '';
  
  installPhase = ''
    install -D git-secrets $out/bin/git-secrets

    wrapProgram $out/bin/git-secrets \
      --prefix PATH : "${lib.makeBinPath [ git ]}"

    # TODO: see above note on rst2man.py
    # mkdir $out/share
    # cp -r man $out/share
  '';

  meta = {
    description = "Prevents you from committing passwords and other sensitive information to a git repository";
    homepage = https://github.com/awslabs/git-secrets;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
  };
}
