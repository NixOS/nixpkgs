{ stdenv, fetchFromGitHub, python3 }:

stdenv.mkDerivation {
  name = "subdl-0.0pre.2017.11.06";

  src = fetchFromGitHub {
    owner = "alexanderwink";
    repo = "subdl";
    rev = "4cf5789b11f0ff3f863b704b336190bf968cd471";
    sha256 = "0kmk5ck1j49q4ww0lvas2767kwnzhkq0vdwkmjypdx5zkxz73fn8";
  };

  meta = {
    homepage = https://github.com/alexanderwink/subdl;
    description = "A command-line tool to download subtitles from opensubtitles.org";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.exfalso ];
  };

  buildInputs = [ python3 ];

  installPhase = ''
    install -vD subdl $out/bin/subdl
  '';  
}
