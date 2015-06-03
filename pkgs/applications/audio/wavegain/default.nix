{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "wavegain-1.3.1";
  src = fetchgit {
    url = "https://github.com/MestreLion/wavegain.git";
    sha256 = "1h886xijc9d7h4p6qx12c6kgwmp6s1bdycnyylkayfncczzlbi24";
  };

  installPhase = ''
    strip -s wavegain
    install -vD wavegain "$out/bin/wavegain"
  '';

  meta = {
    description = "ReplayGain for wave files";
    homepage = https://github.com/MestreLion/wavegain;
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}
