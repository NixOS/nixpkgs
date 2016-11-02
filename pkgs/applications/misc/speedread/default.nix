{ stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation rec {
  version = "git-2016-09-21";
  name = "speedread-${version}";

  src = fetchFromGitHub {
    owner  = "pasky";
    repo   = "speedread";
    rev    = "93acfd61a1bf4482537ce5d71b9164b8446cb6bd";
    sha256 = "1h94jx3v18fdlc64lfmj2g5x63fjyqb8c56k5lihl7bva0xgdkxd";
  };

  buildInputs = [ perl ];

  installPhase = ''
    mkdir -p $out/bin
    mv speedread $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A simple terminal-based open source Spritz-alike";
    longDescription = ''
      Speedread is a command line filter that shows input text as a
      per-word rapid serial visual presentation aligned on optimal
      reading points. This allows reading text at a much more rapid
      pace than usual as the eye can stay fixed on a single place.
    '';
    homepage = src.meta.homepage;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.oxij ];
  };
}
