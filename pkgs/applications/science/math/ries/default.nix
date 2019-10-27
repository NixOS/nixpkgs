{ stdenv, fetchzip }:
stdenv.mkDerivation {
  name = "ries-2018-04-11";

  # upstream does not provide a stable link
  src = fetchzip {
    url = "https://salsa.debian.org/debian/ries/-/archive/debian/2018.04.11-1/ries-debian-2018.04.11-1.zip";
    sha256 = "1h2wvd4k7f0l0i1vm9niz453xdbcs3nxccmri50qyrzzzc1b0842";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = https://mrob.com/pub/ries/;
    description = "Tool to produce a list of equations that approximately solve to a given number";
    platforms = platforms.all;
    maintainers = with maintainers; [ symphorien ];
    license = licenses.gpl3Plus;
  };
}

