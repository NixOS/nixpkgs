{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  git,
  coreutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git-secrets";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "git-secrets";
    rev = finalAttrs.version;
    hash = "sha256-h2FRN2NAoV9rAbB9GucJiDVjM92RAGTaiL8UhMHrloI=";
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

  meta = {
    description = "Prevents you from committing secrets and credentials into git repositories";
    homepage = "https://github.com/awslabs/git-secrets";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    mainProgram = "git-secrets";
  };
})
