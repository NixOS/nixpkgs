{ stdenv, fetchFromGitHub, makeWrapper, perl, ncurses5, taskwarrior }:

stdenv.mkDerivation rec {
  version = "2020-12-17";
  pname = "tasknc";

  src = fetchFromGitHub {
    owner = "lharding";
    repo = "tasknc";
    rev = "a182661fbcc097a933d5e8cce3922eb1734a563e";
    sha256 = "0jrv2k1yizfdjndbl06lmy2bb62ky2rjdk308967j31c5kqqnw56";
  };

  nativeBuildInputs = [
    makeWrapper
    perl # For generating the man pages with pod2man
  ];

  buildInputs = [ ncurses5 ];

  hardeningDisable = [ "format" ];

  buildFlags = [ "VERSION=${version}" ];

  installPhase = ''
    mkdir -p $out/bin/
    mkdir -p $out/share/man/man1
    mkdir -p $out/share/tasknc

    DESTDIR=$out PREFIX= MANPREFIX=/share/man make install

    wrapProgram $out/bin/tasknc --prefix PATH : ${taskwarrior}/bin
  '';


  meta = with stdenv.lib; {
    homepage = "https://github.com/lharding/tasknc";
    description = "A ncurses wrapper around taskwarrior";
    maintainers = with maintainers; [ matthiasbeyer infinisil ];
    platforms = platforms.linux; # Cannot test others
    license = licenses.mit;
  };
}
