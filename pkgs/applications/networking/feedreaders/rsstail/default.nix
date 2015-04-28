{ stdenv, fetchFromGitHub, cppcheck, libmrss }:

let version = "1.9"; in
stdenv.mkDerivation rec {
  name = "rsstail-${version}";

  src = fetchFromGitHub {
    sha256 = "0igkkhwzhi2cxbfirmq5xgaidnv0gdhmh2w7052xqpyvzg069faf";
    rev = "aab4fbcc5cdf82e439ea6abe562e9b648fc1a6ef";
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
    license = with licenses; gpl2Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  buildInputs = [ libmrss ]
    ++ stdenv.lib.optional doCheck cppcheck;

  postPatch = ''
    substituteInPlace Makefile --replace /usr $out
  '';

  enableParallelBuilding = true;

  doCheck = true;

  preInstall = ''
    mkdir -p $out/{bin,share/man/man1}
  '';
}
