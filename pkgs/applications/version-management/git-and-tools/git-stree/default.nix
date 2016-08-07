{ stdenv, lib, fetchFromGitHub, ... }:

stdenv.mkDerivation rec {
  name = "git-stree-${version}";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "tdd";
    repo = "git-stree";
    rev = "0.4.5";
    sha256 = "0y5h44n38w6rhy9m591dvibxpfggj3q950ll7y4h49bhpks4m0l9";
  };

  installPhase = ''
    mkdir -p $out/bin $out/etc/bash_completion.d
    install -m 0755 git-stree $out/bin/
    install -m 0644 git-stree-completion.bash $out/etc/bash_completion.d/
  '';

  meta = with lib; {
    description = "A better Git subtree helper command";
    homepage = http://deliciousinsights.github.io/git-stree;
    license = licenses.mit;
    maintainers = [ maintainers.benley ];
    platforms = platforms.unix;
  };
}
