{ lib
, stdenv
, fetchurl
, libax25
}:

stdenv.mkDerivation rec {
  pname = "ax25-tools";
  version = "0.0.10-rc5";

  buildInputs = [ libax25 ];

  # Due to recent unsolvable administrative domain problems with linux-ax25.org,
  # the new domain is linux-ax25.in-berlin.de
  src = fetchurl {
    url = "https://linux-ax25.in-berlin.de/pub/ax25-tools/ax25-tools-${version}.tar.gz";
    sha256 = "sha256-kqnLi1iobcufVWMPxUyaRsWKIPyTvtUkuMERGQs2qgY=";
  };

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var/lib"
  ];

  meta = with lib; {
    description = "Non-GUI tools used to configure an AX.25 enabled computer";
    homepage = "https://linux-ax25.in-berlin.de/wiki/Main_Page";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ sarcasticadmin ];
    platforms = platforms.linux;
  };
}
