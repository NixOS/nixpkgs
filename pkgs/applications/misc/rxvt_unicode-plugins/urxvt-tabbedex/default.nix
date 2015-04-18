{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "urxvt-tabbedex";

  src = fetchgit {
    url = "https://github.com/mina86/urxvt-tabbedex";
    rev = "54c8d6beb4d65278ed6db24693ca56e1ee65bb42";
    sha256 = "f8734ee289e1cfc517d0699627191c98d32ae3549e0f1935af2a5ccb86d4dc1e";
  };

  installPhase = ''
    install -D tabbedex $out/lib/urxvt/perl/tabbedex
  '';

  meta = with stdenv.lib; {
    description = "Tabbed plugin for rxvt-unicode with many enhancements (mina86's fork)";
    homepage = "https://github.com/mina86/urxvt-tabbedex";
    maintainers = maintainers.abbradar;
  };
}