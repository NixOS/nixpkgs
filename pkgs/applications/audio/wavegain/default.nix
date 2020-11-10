{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "wavegain-1.3.1";
  src = fetchFromGitHub {
    owner = "MestreLion";
    repo = "wavegain";
    rev = "c928eaf97aeec5732625491b64c882e08e314fee";
    sha256 = "0wghqnsbypmr4xcrhb568bfjdnxzzp8qgnws3jslzmzf34dpk5ls";
  };

  installPhase = ''
    strip -s wavegain
    install -vD wavegain "$out/bin/wavegain"
  '';

  meta = {
    description = "ReplayGain for wave files";
    homepage = "https://github.com/MestreLion/wavegain";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.robbinch ];
  };
}
