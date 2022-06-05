{ lib, stdenv, git, xdg-utils, gnugrep, fetchFromGitHub, installShellFiles, makeWrapper, pandoc }:

stdenv.mkDerivation rec {
  pname = "git-open";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "paulirish";
    repo = "git-open";
    rev = "v${version}";
    sha256 = "11n46bngvca5wbdbfcxzjhjbfdbad7sgf7h9gf956cb1q8swsdm0";
  };

  nativeBuildInputs = [ installShellFiles makeWrapper pandoc ];

  buildPhase = ''
    # marked-man is broken and severly outdated.
    # pandoc with some extra metadata is good enough and produces a by man readable file.
    cat <(echo echo '% git-open (1) Version ${version} | Git manual') git-open.1.md > tmp
    mv tmp git-open.1.md
    pandoc --standalone --to man git-open.1.md -o git-open.1
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp git-open $out/bin
    installManPage git-open.1
    wrapProgram $out/bin/git-open \
      --prefix PATH : "${lib.makeBinPath [ git xdg-utils gnugrep ]}"
  '';

  meta = with lib; {
    homepage = "https://github.com/paulirish/git-open";
    description = "Open the GitHub page or website for a repository in your browser";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ jlesquembre SuperSandro2000 ];
  };
}
