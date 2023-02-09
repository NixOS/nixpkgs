{ lib, stdenv, fetchFromGitHub, cppcheck, libmrss, libiconv }:

stdenv.mkDerivation {
  pname = "rsstail";
  version = "2.1";

  src = fetchFromGitHub {
    sha256 = "12p69i3g1fwlw0bds9jqsdmzkid3k5a41w31d227i7vm12wcvjf6";
    rev = "6f2436185372b3f945a4989406c4b6a934fe8a95";
    repo = "rsstail";
    owner = "folkertvanheusden";
  };

  buildInputs = [ libmrss ] ++ lib.optionals stdenv.isDarwin [ libiconv ];
  nativeCheckInputs = [ cppcheck ];

  postPatch = ''
    substituteInPlace Makefile --replace -liconv_hook ""
  '';

  makeFlags = [ "prefix=$(out)" ];
  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "Monitor RSS feeds for new entries";
    longDescription = ''
      RSSTail is more or less an RSS reader: it monitors an RSS feed and if it
      detects a new entry it'll emit only that new entry.
    '';
    homepage = "http://www.vanheusden.com/rsstail/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.Necior ];
    platforms = platforms.unix;
  };
}
