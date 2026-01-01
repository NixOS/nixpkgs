{
  lib,
  stdenv,
  fetchzip,
}:
stdenv.mkDerivation rec {
  pname = "ries";
  version = "2018.04.11-1";

  # upstream does not provide a stable link
  src = fetchzip {
    url = "https://salsa.debian.org/debian/ries/-/archive/debian/${version}/ries-debian-${version}.zip";
    sha256 = "1h2wvd4k7f0l0i1vm9niz453xdbcs3nxccmri50qyrzzzc1b0842";
  };

  makeFlags = [ "PREFIX=$(out)" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://mrob.com/pub/ries/";
    description = "Tool to produce a list of equations that approximately solve to a given number";
    mainProgram = "ries";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ symphorien ];
    license = lib.licenses.gpl3Plus;
=======
  meta = with lib; {
    homepage = "https://mrob.com/pub/ries/";
    description = "Tool to produce a list of equations that approximately solve to a given number";
    mainProgram = "ries";
    platforms = platforms.all;
    maintainers = with maintainers; [ symphorien ];
    license = licenses.gpl3Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
