{stdenv, git, xdg_utils, gnugrep, fetchFromGitHub, makeWrapper}:

stdenv.mkDerivation rec {
  name = "git-open-${version}";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "paulirish";
    repo = "git-open";
    rev = "v${version}";
    sha256 = "1klj41vqgyyigqzi6s1ykz9vd8wvaq3skin63pi989dlsjf7igyr";
  };

  buildInputs = [ makeWrapper ];

  buildPhase = null;

  installPhase = ''
    mkdir -p $out/bin
    cp git-open $out/bin
    wrapProgram $out/bin/git-open \
      --prefix PATH : "${stdenv.lib.makeBinPath [ git xdg_utils gnugrep ]}"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/paulirish/git-open;
    description = "Open the GitHub page or website for a repository in your browser";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.jlesquembre ];
  };
}
