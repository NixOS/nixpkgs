{ lib
, fetchurl
, python2
}:
python2.pkgs.buildPythonApplication rec {
  pname = "chirp-daily";
  version = "20220823";

  src = fetchurl {
    url = "https://trac.chirp.danplanet.com/chirp_daily/daily-${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-V+8HQAYU2XjOYeku0XEHqkY4m0XjiUBxM61QcupnlVM=";
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
