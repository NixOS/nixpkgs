{ stdenv, fetchFromGitHub, cppcheck, libmrss }:

let version = "1.9.1"; in
stdenv.mkDerivation rec {
  name = "rsstail-${version}";

  src = fetchFromGitHub {
    sha256 = "0jhf7vr7y56r751wy4ix80iwhgxhk6mbbin8gnx59i457gf6sjl1";
    rev = "1220d63aaa233961636f859d9a406536fffb64f4";
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
    substituteInPlace Makefile --replace /usr $out
  '';

  enableParallelBuilding = true;

  doCheck = true;

  preInstall = ''
    mkdir -p $out/{bin,share/man/man1}
  '';
}
