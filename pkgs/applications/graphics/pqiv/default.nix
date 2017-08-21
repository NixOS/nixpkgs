{ stdenv, fetchFromGitHub, getopt, which, pkgconfig, gtk2 } :

stdenv.mkDerivation (rec {
  name = "pqiv-${version}";
  version = "2.9";

  src = fetchFromGitHub {
    owner = "phillipberndt";
    repo = "pqiv";
    rev = version;
    sha256 = "1xncf6aq52zpxpmz3ikmlkinz7y3nmbpgfxjb7q40sqs00n0mfsd";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ getopt which gtk2 ];

  prePatch = "patchShebangs .";

  meta = with stdenv.lib; {
    description = "Rewrite of qiv (quick image viewer)";
    homepage = http://www.pberndt.com/Programme/Linux/pqiv;
    license = licenses.gpl3;
    maintainers = [ maintainers.ndowens ];
    platforms = platforms.unix;
  };
})
