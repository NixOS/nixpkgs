{ lib, stdenv, fetchFromGitHub, makeWrapper, git }:

stdenv.mkDerivation rec {
  pname = "git-standup";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "kamranahmedse";
    repo = pname;
    rev = version;
    sha256 = "1xnn0jjha56v7l2vj45zzxncl6m5x2hq6nkffgc1bcikhp1pidn7";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    install -Dm755 -t $out/bin git-standup

    wrapProgram $out/bin/git-standup \
      --prefix PATH : "${lib.makeBinPath [ git ]}"
  '';

  meta = with lib; {
    description = "Recall what you did on the last working day";
    homepage = "https://github.com/kamranahmedse/git-standup";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
    mainProgram = "git-standup";
  };
}
