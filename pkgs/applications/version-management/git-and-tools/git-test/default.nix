{ stdenv, fetchFromGitHub, makeWrapper, git }:

stdenv.mkDerivation rec {
  name = "git-test-${version}";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "spotify";
    repo = "git-test";
    rev = "v${version}";
    sha256 = "01h3f0andv1p7pwir3k6n01v92hgr5zbjadfwl144yjw9x37fm2f";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    install -m755 -Dt $out/bin git-test
    install -m444 -Dt $out/share/man/man1 git-test.1

    wrapProgram $out/bin/git-test \
      --prefix PATH : "${stdenv.lib.makeBinPath [ git ]}"
  '';

  meta = with stdenv.lib; {
    description = "Test your commits";
    homepage = https://github.com/spotify/git-test;
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
