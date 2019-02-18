{ stdenv, fetchFromGitHub, makeWrapper, git, coreutils }:

stdenv.mkDerivation rec {
  name = "git-secrets-${version}";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "git-secrets";
    rev = "${version}";
    sha256 = "14jsm4ks3k5d9iq3jr23829izw040pqpmv7dz8fhmvx6qz8fybzg";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    install -m755 -Dt $out/bin git-secrets
    install -m444 -Dt $out/share/man/man1 git-secrets.1

    wrapProgram $out/bin/git-secrets \
      --prefix PATH : "${stdenv.lib.makeBinPath [ git coreutils ]}"
  '';

  meta = with stdenv.lib; {
    description = "Prevents you from committing secrets and credentials into git repositories";
    homepage = https://github.com/awslabs/git-secrets;
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
