{ stdenv, fetchFromGitHub, makeWrapper, git }:

stdenv.mkDerivation rec {
  pname = "git-standup";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "kamranahmedse";
    repo = pname;
    rev = version;
    sha256 = "0wx9ypyxhpjbrasl6264jmj9fjrpg3gn93dg00cakabz3r7yxxq3";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    install -Dm755 -t $out/bin git-standup

    wrapProgram $out/bin/git-standup \
      --prefix PATH : "${stdenv.lib.makeBinPath [ git ]}"
  '';

  meta = with stdenv.lib; {
    description = "Recall what you did on the last working day";
    homepage = "https://github.com/kamranahmedse/git-standup";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
