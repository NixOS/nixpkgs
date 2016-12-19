{ stdenv, fetchFromGitHub, opal, ptlib }:

stdenv.mkDerivation rec {

  rev = "3090e9f";

  name = "sipcmd-${rev}";
  
  src = fetchFromGitHub {
    repo = "sipcmd";
    owner = "tmakkonen";
    inherit rev;
    sha256 = "072h9qapmz46r8pxbzkfmc4ikd7dv9g8cgrfrw21q942icbrvq2c";
  };

  buildInputs = [ opal ptlib ];

  buildPhase = ''
    make IFLAGS="-I${opal}/include/opal -I${ptlib}/include -Isrc/ -L${opal}/lib -L${ptlib}/lib"
  '';

  installPhase = ''
    mkdir -pv $out/bin
    cp sipcmd $out/bin/sipcmd
  '';

  meta = {
    homepage = https://github.com/tmakkonen/sipcmd;
    description = "The command line SIP/H.323/RTP softphone";
    platforms = with stdenv.lib.platforms; linux;
  };
}

