{ stdenv, fetchFromGitHub, makeWrapper, perl, ncurses5, taskwarrior }:

stdenv.mkDerivation rec {
  version = "2017-05-15";
  name = "tasknc-${version}";

  src = fetchFromGitHub {
    owner = "lharding";
    repo = "tasknc";
    rev = "c41d0240e9b848e432f01de735f28de93b934ae7";
    sha256 = "0f7l7fy06p33vw6f6sjnjxfhw951664pmwhjl573jvmh6gi2h1yr";
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
    homepage = https://github.com/lharding/tasknc;
    description = "A ncurses wrapper around taskwarrior";
    maintainers = with maintainers; [ matthiasbeyer infinisil ];
    platforms = platforms.linux; # Cannot test others
    license = licenses.mit;
  };
}
