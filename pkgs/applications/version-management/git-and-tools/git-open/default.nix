{stdenv, git, xdg_utils, gnugrep, fetchFromGitHub, makeWrapper}:

stdenv.mkDerivation rec {
  name = "git-open-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "paulirish";
    repo = "git-open";
    rev = "v${version}";
    sha256 = "0lprzrjsqrg83gixfaiw26achgd8l7s56jknsjss4p7y0w1fxm05";
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
