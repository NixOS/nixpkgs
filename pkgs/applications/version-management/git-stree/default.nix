{ stdenv, lib, fetchFromGitHub, ... }:

stdenv.mkDerivation {
  pname = "git-stree";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "tdd";
    repo = "git-stree";
    rev = "0.4.5";
    sha256 = "0y5h44n38w6rhy9m591dvibxpfggj3q950ll7y4h49bhpks4m0l9";
  };

  installPhase = ''
    mkdir -p $out/bin $out/share/bash-completion/completions
    install -m 0755 git-stree $out/bin/
    install -m 0644 git-stree-completion.bash $out/share/bash-completion/completions/
  '';

  meta = with lib; {
    description = "Better Git subtree helper command";
    homepage = "http://deliciousinsights.github.io/git-stree";
    license = licenses.mit;
    maintainers = [ maintainers.benley ];
    platforms = platforms.unix;
    mainProgram = "git-stree";
  };
}
