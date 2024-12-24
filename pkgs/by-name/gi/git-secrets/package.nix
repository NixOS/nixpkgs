{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  git,
  coreutils,
}:

stdenv.mkDerivation rec {
  pname = "git-secrets";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "git-secrets";
    rev = version;
    sha256 = "10lnxg0q855zi3d6804ivlrn6dc817kilzdh05mmz8a0ccvm2qc7";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    install -m755 -Dt $out/bin git-secrets
    install -m444 -Dt $out/share/man/man1 git-secrets.1

    wrapProgram $out/bin/git-secrets \
      --prefix PATH : "${
        lib.makeBinPath [
          git
          coreutils
        ]
      }"
  '';

  meta = with lib; {
    description = "Prevents you from committing secrets and credentials into git repositories";
    homepage = "https://github.com/awslabs/git-secrets";
    license = licenses.asl20;
    platforms = platforms.all;
    mainProgram = "git-secrets";
  };
}
