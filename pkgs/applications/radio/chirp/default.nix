{ stdenv
, fetchurl
, python2
}:
python2.pkgs.buildPythonApplication rec {
  pname = "chirp-daily";
  version = "20200409";

  src = fetchurl {
    url = "https://trac.chirp.danplanet.com/chirp_daily/daily-${version}/${pname}-${version}.tar.gz";
    sha256 = "16zhwg2xmp5kpqx5isavwwkfq1212zgfj8gbp453ngjcrvp3m4lq";
  };

  propagatedBuildInputs = with python2.pkgs; [
    pygtk pyserial libxml2 future
  ];

  meta = with stdenv.lib; {
    description = "A free, open-source tool for programming your amateur radio";
    homepage = "https://chirp.danplanet.com/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.the-kenny ];
  };
}
