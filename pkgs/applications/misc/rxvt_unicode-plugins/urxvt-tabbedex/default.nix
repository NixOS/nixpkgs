{ stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation rec {
  pname = "urxvt-tabbedex";
  version = "19.21";

  src = fetchFromGitHub {
    owner = "mina86";
    repo = "urxvt-tabbedex";
    rev = "v${version}";
    sha256 = "06msd156h6r8ss7qg66sjz5jz8613qfq2yvp0pc24i6mxzj8vl77";
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
