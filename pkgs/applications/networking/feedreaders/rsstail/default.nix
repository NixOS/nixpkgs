{ stdenv, fetchFromGitHub, cppcheck, libmrss }:

let version = "2.0"; in
stdenv.mkDerivation rec {
  name = "rsstail-${version}";

  src = fetchFromGitHub {
    sha256 = "0fbsyl5bdxr2g25ps7kd34sa0mzggklbg4v7qss68gh82zdp16ch";
    rev = "69dc5e30439b89c037aa49c5af861f28df607c72";
    repo = "rsstail";
    owner = "flok99";
  };

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

  buildInputs = [ libmrss ]
    ++ stdenv.lib.optional doCheck cppcheck;

  postPatch = ''
    substituteInPlace Makefile --replace -liconv ""
  '';

  makeFlags = "prefix=$(out)";
  enableParallelBuilding = true;

  doCheck = true;
}
