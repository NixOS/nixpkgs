{ lib, stdenv, fetchFromGitHub, git, makeWrapper, which, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "git-subrepo";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "ingydotnet";
    repo = "git-subrepo";
    rev = version;
    sha256 = "sha256-ZU5yYaiear5AjlBqtzabmMJNUa2ypeJKW3sQPIcyskM=";
  };

  nativeBuildInputs = [
    makeWrapper
    which
    installShellFiles
  ];

  buildInputs = [
    git
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "INSTALL_LIB=${placeholder "out"}/bin"
    "INSTALL_MAN=${placeholder "out"}/share/man/man1"
  ];

  postInstall = ''
    installShellCompletion --bash --name git-subrepo.bash share/completion.bash
    installShellCompletion --zsh share/zsh-completion/_git-subrepo
  '';

  postFixup = ''
    wrapProgram $out/bin/git-subrepo \
      --prefix PATH : "${git}/bin"
  '';

  meta = with lib; {
    homepage = "https://github.com/ingydotnet/git-subrepo";
    description = "Git submodule alternative";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ryantrinkle ];
  };
}
