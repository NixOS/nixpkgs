{ lib
, stdenv
, fetchurl
, libax25
, ncurses
}:

stdenv.mkDerivation rec {
  pname = "ax25-apps";
  version = "0.0.8-rc5";

  buildInputs = [ libax25 ncurses ];

  # Due to recent unsolvable administrative domain problems with linux-ax25.org,
  # the new domain is linux-ax25.in-berlin.de
  src = fetchurl {
    url = "https://linux-ax25.in-berlin.de/pub/ax25-apps/ax25-apps-${version}.tar.gz";
    sha256 = "sha256-MzQOIyy5tbJKmojMrgtOcsaQTFJvs3rqt2hUgholz5Y=";
  };

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var/lib"
    "--program-transform-name=s@^call$@ax&@;s@^listen$@ax&@"
  ];

  meta = with lib; {
    description = "AX.25 ham radio applications";
    homepage = "https://linux-ax25.in-berlin.de/wiki/Main_Page";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ sarcasticadmin ];
    platforms = platforms.linux;
  };
}
