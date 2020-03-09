{ stdenv
, fetchurl
, python2
}:
python2.pkgs.buildPythonApplication rec {
  pname = "chirp-daily";
  version = "20200213";

  src = fetchurl {
    url = "https://trac.chirp.danplanet.com/chirp_daily/daily-${version}/${pname}-${version}.tar.gz";
    sha256 = "189kg3425wggib1cggcj49bk01pq3j4b8mks7najpp1rjsl5f2i1";
  };

  propagatedBuildInputs = with python2.pkgs; [
    pygtk pyserial libxml2 future
  ];

  meta = with stdenv.lib; {
    description = "A free, open-source tool for programming your amateur radio";
    homepage = https://chirp.danplanet.com/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.the-kenny ];
  };
}
