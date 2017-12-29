{ stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation {
  name = "urxvt-tabbedex-2016-08-17";

  src = fetchFromGitHub {
    owner = "mina86";
    repo = "urxvt-tabbedex";
    rev = "089d0cb724eeb62fa8a5dfcb00ced7761e794149";
    sha256 = "0a5jrb7ryafj55fgi8fhpy3gmb1xh5j7pbn8p5j5k6s2fnh0g0hq";
  };

  nativeBuildInputs = [ perl ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Tabbed plugin for rxvt-unicode with many enhancements (mina86's fork)";
    homepage = https://github.com/mina86/urxvt-tabbedex;
    maintainers = with maintainers; [ abbradar ];
    platforms = with platforms; unix;
  };
}
