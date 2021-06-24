{lib, stdenv, git, xdg-utils, gnugrep, fetchFromGitHub, makeWrapper}:

stdenv.mkDerivation rec {
  pname = "git-open";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "paulirish";
    repo = "git-open";
    rev = "v${version}";
    sha256 = "11n46bngvca5wbdbfcxzjhjbfdbad7sgf7h9gf956cb1q8swsdm0";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = null;

  installPhase = ''
    mkdir -p $out/bin
    cp git-open $out/bin
    wrapProgram $out/bin/git-open \
      --prefix PATH : "${lib.makeBinPath [ git xdg-utils gnugrep ]}"
  '';

  meta = with lib; {
    homepage = "https://github.com/paulirish/git-open";
    description = "Open the GitHub page or website for a repository in your browser";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.jlesquembre ];
  };
}
