{ lib, stdenv, python, perl, fetchFromGitHub, installShellFiles }:
stdenv.mkDerivation rec {
  pname = "git-publish";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "stefanha";
    repo = "git-publish";
    rev = "v${version}";
    hash = "sha256-jjpbr+ZqG4U8/z0PurnXR+IUKQkG3QB8YqhDkH8uu2Y=";
  };

  nativeBuildInputs = [ perl installShellFiles ];
  buildInputs = [ python ];

  installPhase = ''
    runHook preInstall

    install -Dm0755 git-publish $out/bin/git-publish
    pod2man git-publish.pod > git-publish.1
    installManPage git-publish.1

    runHook postInstall
  '';

  meta = {
    description = "Prepare and store patch revisions as git tags";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lheckemann ];
    homepage = "https://github.com/stefanha/git-publish";
    mainProgram = "git-publish";
  };
}
