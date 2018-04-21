{ pkgs, fetchgit, stdenv, makeWrapper, taskwarrior, ncurses,
perl, perlPackages }:

let
  version = "1.2";
in
stdenv.mkDerivation {
  name = "vit-${version}";

  src = fetchgit {
    url = "https://git.tasktools.org/scm/ex/vit.git";
    rev = "7d0042ca30e9d09cfbf9743b3bc72096e4a8fe1e";
    sha256 = "92cad7169b3870145dff02256e547ae270996a314b841d3daed392ac6722827f";
  };

  preConfigure = ''
    substituteInPlace Makefile.in \
      --replace sudo ""
    substituteInPlace configure \
      --replace /usr/bin/perl ${perl}/bin/perl
  '';

  postInstall = ''
    wrapProgram $out/bin/vit --prefix PERL5LIB : $PERL5LIB
  '';

  buildInputs = [ taskwarrior ncurses perlPackages.Curses perl makeWrapper ];

  meta = {
    description = "Visual Interactive Taskwarrior";
    maintainers = with pkgs.lib.maintainers; [ ];
    platforms = pkgs.lib.platforms.linux;
    license = pkgs.lib.licenses.gpl3;
  };
}

