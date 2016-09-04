{ stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation {
  name = "urxvt-tabbedex-2016-08-09";

  src = fetchFromGitHub {
    owner = "mina86";
    repo = "urxvt-tabbedex";
    rev = "ac220eb3984e151ba14dce08f446bc7bc8ca29a2";
    sha256 = "1b5mff5137jb5ysklsmfp5ql3m4g1z3bdhk0nwhz2hgwz40ap6k8";
  };

  nativeBuildInputs = [ perl ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Tabbed plugin for rxvt-unicode with many enhancements (mina86's fork)";
    homepage = "https://github.com/mina86/urxvt-tabbedex";
    maintainers = with maintainers; [ abbradar ];
    platforms = with platforms; unix;
  };
}
