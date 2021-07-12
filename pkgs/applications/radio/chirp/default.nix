{ lib
, fetchurl
, python2
}:
python2.pkgs.buildPythonApplication rec {
  pname = "chirp-daily";
  version = "20200807";

  src = fetchurl {
    url = "https://trac.chirp.danplanet.com/chirp_daily/daily-${version}/${pname}-${version}.tar.gz";
    sha256 = "60b682793698e6427ad485546eae3a044b8290a220f190633158a2fb0e942fa0";
  };

  propagatedBuildInputs = with python2.pkgs; [
    pygtk pyserial libxml2 future
  ];

  meta = with lib; {
    description = "A free, open-source tool for programming your amateur radio";
    homepage = "https://chirp.danplanet.com/";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
