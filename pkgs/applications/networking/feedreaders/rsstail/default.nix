{ lib, stdenv, fetchFromGitHub, libmrss, libiconv }:

stdenv.mkDerivation {
  pname = "rsstail";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "folkertvanheusden";
    repo = "rsstail";
    rev = "6f2436185372b3f945a4989406c4b6a934fe8a95";
    sha256 = "12p69i3g1fwlw0bds9jqsdmzkid3k5a41w31d227i7vm12wcvjf6";
  };

  buildInputs = [ libmrss ] ++ lib.optionals stdenv.isDarwin [ libiconv ];

  postPatch = ''
    substituteInPlace Makefile --replace -liconv_hook ""
  '';

  makeFlags = [ "prefix=$(out)" ];
  enableParallelBuilding = true;

  # just runs cppcheck linter
  doCheck = false;

  meta = with lib; {
    description = "Monitor RSS feeds for new entries";
    mainProgram = "rsstail";
    longDescription = ''
      RSSTail is more or less an RSS reader: it monitors an RSS feed and if it
      detects a new entry it'll emit only that new entry.
    '';
    homepage = "https://www.vanheusden.com/rsstail/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.Necior ];
    platforms = platforms.unix;
  };
}
