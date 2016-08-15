{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "urxvt-tabbedex-2015-03-03";

  src = fetchgit {
    url = "https://github.com/mina86/urxvt-tabbedex";
    rev = "b0a02018b1cbaaba2a0c8ea7af9368db0adf3363";
    sha256 = "f0025f2741d424736620147d9fc39faac68193cb9f74bde0fb6e02a6f1ae61c3";
  };

  installPhase = ''
    install -D tabbedex $out/lib/urxvt/perl/tabbedex
  '';

  meta = with stdenv.lib; {
    description = "Tabbed plugin for rxvt-unicode with many enhancements (mina86's fork)";
    homepage = "https://github.com/mina86/urxvt-tabbedex";
    maintainers = with maintainers; [ abbradar ];
    platforms = with platforms; unix;
  };
}
