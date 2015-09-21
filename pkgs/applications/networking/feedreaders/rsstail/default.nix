{ stdenv, fetchFromGitHub, cppcheck, libmrss }:

let version = "2015-09-06"; in
stdenv.mkDerivation rec {
  name = "rsstail-${version}";

  src = fetchFromGitHub {
    sha256 = "1rfzib5fzm0i8wf3njld1lvxgbci0hxxnvp2qx1k4bwpv744xkpx";
    rev = "16636539e4cc75dafbfa7f05539769be7dad4b66";
    repo = "rsstail";
    owner = "flok99";
  };

  buildInputs = [ libmrss ]
    ++ stdenv.lib.optional doCheck cppcheck;

  postPatch = ''
    substituteInPlace Makefile --replace -liconv ""
  '';

  makeFlags = "prefix=$(out)";
  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    inherit version;
    description = "Monitor RSS feeds for new entries";
    longDescription = ''
      RSSTail is more or less an RSS reader: it monitors an RSS feed and if it
      detects a new entry it'll emit only that new entry.
    '';
    homepage = http://www.vanheusden.com/rsstail/;
    license = licenses.gpl2Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };
}
